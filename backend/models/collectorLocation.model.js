const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const User = require('./user.model');

const CollectorLocation = sequelize.define('CollectorLocation', {
    lat: {
        type: DataTypes.FLOAT,
        allowNull: false
    },
    lng: {
        type: DataTypes.FLOAT,
        allowNull: false
    },
    isActive: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
    }
}, {
    timestamps: true,
    tableName: 'collector_locations'
});

// Create relationship: A CollectorLocation connects to a Collector User ID.
CollectorLocation.belongsTo(User, { foreignKey: 'uid' });

module.exports = CollectorLocation;
