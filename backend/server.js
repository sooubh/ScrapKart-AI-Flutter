const express = require('express');
const cors = require('cors');
const sequelize = require('./config/database');
const authRoutes = require('./routes/auth.routes');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// Routes
app.use('/api/auth', authRoutes);
const scrapRoutes = require('./routes/scrap.routes');
app.use('/api/scrap', scrapRoutes);
const bookingRoutes = require('./routes/booking.routes');
app.use('/api/booking', bookingRoutes);
const chatRoutes = require('./routes/chat.routes');
app.use('/api/chat', chatRoutes);

// Database Sync & Server Initialization
sequelize.sync({ alter: true }) // Adjust in production: alter/force should be used with caution
    .then(() => {
        console.log('✅ MySQL Database connected & synced.');
    })
    .catch((err) => {
        console.error('❌ Failed to connect database (App will run without DB):', err.message);
    });

app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});
