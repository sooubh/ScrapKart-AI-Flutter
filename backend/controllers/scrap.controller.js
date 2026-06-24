const multer = require('multer');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const ScrapRate = require('../models/scrapRate.model');

// Using the provided Gemini API key
const apiKey = 'AIzaSyD49LbkJ0MbXYFxrin_PEPDcx48uSgxoaM';
const genAI = new GoogleGenerativeAI(apiKey);

// Setup multer for handling multipart form-data cleanly in memory
const storage = multer.memoryStorage();
exports.upload = multer({ storage: storage });

exports.scanScrap = async (req, res) => {
    try {
        // Simulate processing delay for "AI" feel
        await new Promise(resolve => setTimeout(resolve, 2000));

        // Randomly select material and condition for dummy mode
        const materials = ['Plastic', 'Metal', 'Paper', 'Glass', 'Electronics'];
        const material = materials[Math.floor(Math.random() * materials.length)];
        const conditionFactor = (Math.random() * (1.0 - 0.4) + 0.4).toFixed(2); // Random between 0.4 and 1.0

        // Default rates mapping
        const rates = {
            'Plastic': 12.0,
            'Metal': 45.0,
            'Paper': 8.0,
            'Glass': 5.0,
            'Electronics': 80.0
        };

        const baseRate = rates[material] || 15.0;
        const weight = parseFloat(req.body.weight) || 2.0;
        const estimatedPrice = (baseRate * conditionFactor * weight).toFixed(2);

        console.log(`[DUMMY SCAN] Detected: ${material}, Condition: ${conditionFactor}, Price: ${estimatedPrice}`);

        return res.status(200).json({
            success: true,
            data: {
                material: material,
                conditionFactor: parseFloat(conditionFactor),
                baseRate: baseRate,
                weight: weight,
                estimatedPrice: estimatedPrice
            }
        });

    } catch (error) {
        console.error("Dummy Scan Error:", error);
        return res.status(500).json({ success: false, message: "Error running Dummy Scan logic", error: error.message });
    }
};
