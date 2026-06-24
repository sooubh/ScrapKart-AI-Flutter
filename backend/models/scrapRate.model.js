const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ScrapRate = sequelize.define('ScrapRate', {
    material: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    baseRate: {
        type: DataTypes.FLOAT,
        allowNull: false
    }
}, {
    timestamps: false,
    tableName: 'scrap_rates'
});

module.exports = ScrapRate;
