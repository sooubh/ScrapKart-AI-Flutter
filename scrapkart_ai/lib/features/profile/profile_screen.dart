import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Profile Info
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.secondary.withOpacity(0.3),
                  child: const Icon(Icons.person, size: 50, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text('Karan', style: AppTextStyles.headline),
                Text('karan@example.com', style: AppTextStyles.body),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCol('45kg', 'Total Sold'),
                    Container(width: 1, height: 40, color: Colors.white),
                    _buildStatCol('₹ 2,450', 'Earnings'),
                    Container(width: 1, height: 40, color: Colors.white),
                    _buildStatCol('12', 'Pickups'),
                  ],
                ),
              ],
            ),
          ).animate().slideY(begin: -0.2).fadeIn(),
          
          const SizedBox(height: 32),
          
          // Options List
          _buildOptionTile(Icons.restore_rounded, 'Order History', AppColors.tertiary).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
          _buildOptionTile(Icons.payment_rounded, 'Payment Methods', AppColors.accent).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),
          _buildOptionTile(Icons.location_on_rounded, 'Saved Addresses', AppColors.secondary).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 16),
          _buildOptionTile(Icons.settings_rounded, 'Settings', AppColors.primary).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 16),
          _buildOptionTile(Icons.logout_rounded, 'Logout', Colors.redAccent).animate().fadeIn(delay: 600.ms),
          
          const SizedBox(height: 100), // App bar padding
        ],
      ),
    );
  }

  Widget _buildStatCol(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.title.copyWith(color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.body.copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _buildOptionTile(IconData icon, String title, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: AppTextStyles.title.copyWith(fontSize: 16))),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
