const User = require('../models/user.model');

exports.syncUser = async (req, res) => {
    try {
        const { uid, name, email, role } = req.body;

        if (!uid || !email) {
            return res.status(400).json({ success: false, message: 'UID and Email are required.' });
        }

        // Check if user already exists
        let user = await User.findByPk(uid);
        
        if (user) {
            // Update user details if needed (e.g. they changed name via Google Sign-In)
            user.name = name || user.name;
            user.email = email || user.email;
            if (role) user.role = role;
            await user.save();
        } else {
            // Register new user
            user = await User.create({
                uid,
                name: name || 'ScrapKart User',
                email,
                role: role || 'User'
            });
        }

        return res.status(200).json({ success: true, message: 'User synced successfully', data: user });
    } catch (error) {
        console.error('Error syncing user to database:', error);
        return res.status(500).json({ success: false, message: 'Internal Server Error' });
    }
};
