const { Sequelize } = require('sequelize');

// Replace these values with your actual MySQL credentials
// e.g. 'DB_NAME', 'DB_USER', 'DB_PASSWORD'
const sequelize = new Sequelize('scrapkart_db', 'root', 'password', {
    host: 'localhost',
    dialect: 'mysql',
    logging: false, // Set to true if you want to see raw SQL queries in console
});

module.exports = sequelize;
