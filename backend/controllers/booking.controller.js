const sequelize = require('../config/database');
const CollectorLocation = require('../models/collectorLocation.model');
const User = require('../models/user.model');
const axios = require('axios');

// Generates MySQL raw query implementing the Haversine formula
const generateHaversineQuery = (lat, lng, radiusKm) => {
    return `
        SELECT cl.*, u.name, u.email,
        (6371 * acos(cos(radians(${lat})) * cos(radians(cl.lat)) * cos(radians(cl.lng) - radians(${lng})) + sin(radians(${lat})) * sin(radians(cl.lat)))) AS distance
        FROM collector_locations AS cl
        JOIN users AS u ON cl.uid = u.uid
        WHERE cl.isActive = true
        HAVING distance < ${radiusKm}
        ORDER BY distance LIMIT 10
    `;
};

exports.assignCollector = async (req, res) => {
    try {
        const { lat, lng } = req.body;
        
        if (!lat || !lng) {
             return res.status(400).json({ success: false, message: 'Latitude and Longitude are required' });
        }

        // 1. Filter Initial Radius (5 KM) executing Haversine in MySQL Database
        const activeCollectors = await sequelize.query(generateHaversineQuery(lat, lng, 5), {
            type: sequelize.QueryTypes.SELECT
        });

        if (activeCollectors.length === 0) {
            return res.status(404).json({ success: false, message: 'No collectors found within a 5km area.' });
        }

        // 2. Formatting destinations for Google Distance Matrix API Evaluation
        const destinations = activeCollectors.map(c => `${c.lat},${c.lng}`).join('|');
        const origins = `${lat},${lng}`;
        
        // The Maps key shouldn't be hardcoded physically but implemented securely via .env
        const mapApiKey = process.env.GOOGLE_MAPS_API_KEY || 'AIzaSy_YOUR_MATRIX_KEY_HERE';
        
        const dmUrl = `https://maps.googleapis.com/maps/api/distancematrix/json?origins=${origins}&destinations=${destinations}&key=${mapApiKey}`;
        
        let elements = [];
        try {
            const dmResponse = await axios.get(dmUrl);
            if (dmResponse.data && dmResponse.data.rows && dmResponse.data.rows.length > 0) {
                elements = dmResponse.data.rows[0].elements;
            }
        } catch (axiosErr) {
            console.error("Distance Matrix error:", axiosErr.message);
            // Will fallback to straight-line haversine distance
        }

        let bestCollector = null;
        let minDuration = Infinity;

        // 3. Find Collector with Minimal Real-World ETA Time
        if (elements.length > 0) {
            for (let i = 0; i < elements.length; i++) {
                const el = elements[i];
                if (el.status === 'OK') {
                    const durationValue = el.duration.value; // evaluated natively in seconds
                    if (durationValue < minDuration) {
                        minDuration = durationValue;
                        bestCollector = {
                            ...activeCollectors[i],
                            eta: el.duration.text,
                            drivingDistance: el.distance.text
                        };
                    }
                }
            }
        }

        // Fallback safety logic bridging raw Haversine math if API errors occurs
        if (!bestCollector) {
            bestCollector = activeCollectors[0];
            bestCollector.eta = 'ETA Unavailable';
            bestCollector.drivingDistance = `${bestCollector.distance.toFixed(1)} km`;
        }

        return res.status(200).json({
            success: true,
            message: 'Collector located and assigned.',
            collector: bestCollector
        });

    } catch (error) {
        console.error("Booking Error:", error);
        return res.status(500).json({ success: false, message: 'Server error processing logistics.' });
    }
};
