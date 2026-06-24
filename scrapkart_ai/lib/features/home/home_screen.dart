import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onScanTap;
  
  const HomeScreen({super.key, this.onProfileTap, this.onScanTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Greeting Map
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   Image.asset('assets/images/logo.png', width: 40, height: 40),
                   const SizedBox(width: 12),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, Karan 👋', style: AppTextStyles.headline.copyWith(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text('ScrapKart AI', style: AppTextStyles.subtitle.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ).animate().slideX(begin: -0.2).fadeIn(),
              GestureDetector(
                onTap: onProfileTap,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.tertiary.withOpacity(0.5),
                  child: const Icon(Icons.person, color: AppColors.primary),
                ).animate().scale().fadeIn(),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Stats Card
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Earnings', style: AppTextStyles.body),
                    const SizedBox(height: 8),
                    Text('₹ 2,450', style: AppTextStyles.headline.copyWith(color: AppColors.primary)),
                    const SizedBox(height: 16),
                    Text('Scrap Sold', style: AppTextStyles.body),
                    const SizedBox(height: 4),
                    Text('45 kg', style: AppTextStyles.title.copyWith(fontSize: 18)),
                  ],
                ),
                const SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 0.7,
                        strokeWidth: 10,
                        backgroundColor: Colors.white,
                        color: AppColors.tertiary,
                      ),
                      Icon(Icons.eco, color: AppColors.primary, size: 30),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().slideY(begin: 0.2).fadeIn(),
          
          const SizedBox(height: 32),
          
          // Quick Actions
          Text('Quick Actions', style: AppTextStyles.title)
              .animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _buildActionCard(
                  context,
                  title: 'Sell Scrap',
                  icon: Icons.sell_rounded,
                  color: AppColors.secondary,
                  onTap: () => context.push('/booking'),
                  delay: 300,
                ),
                const SizedBox(width: 16),
                _buildActionCard(
                  context,
                  title: 'AI Scan',
                  icon: Icons.document_scanner_rounded,
                  color: AppColors.primary,
                  onTap: onScanTap ?? () => context.go('/scan'),
                  delay: 400,
                ),
                const SizedBox(width: 16),
                _buildActionCard(
                  context,
                  title: 'Donate',
                  icon: Icons.volunteer_activism_rounded,
                  color: AppColors.tertiary,
                  onTap: () => context.push('/donate'),
                  delay: 500,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // AI Recommendations
          Text('AI Recommendations', style: AppTextStyles.title)
              .animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 16),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRecommendationItem('Plastic bottle', 'Recycle', Icons.recycling),
                const Divider(color: Colors.white),
                _buildRecommendationItem('Old clothes', 'Donate', Icons.checkroom),
              ],
            ),
          ).animate().slideY(begin: 0.2).fadeIn(delay: 700.ms),
          
          const SizedBox(height: 32),
          
          // Recent Activity
          Text('Recent Activity', style: AppTextStyles.title)
              .animate().fadeIn(delay: 800.ms),
          const SizedBox(height: 16),
          _buildRecentActivityItem('Newspaper (10kg)', 'Completed', '12 Oct, 10:00 AM', AppColors.tertiary)
              .animate().slideY(begin: 0.2).fadeIn(delay: 900.ms),
          const SizedBox(height: 12),
          _buildRecentActivityItem('E-Waste (2kg)', 'Processing', '15 Oct, 02:30 PM', AppColors.accent)
              .animate().slideY(begin: 0.2).fadeIn(delay: 1000.ms),
              
          const SizedBox(height: 100), // padding for bottom nav
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap, required int delay}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().scale(delay: delay.ms).fadeIn(delay: delay.ms);
  }

  Widget _buildRecommendationItem(String item, String action, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(item, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              action,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityItem(String title, String status, String date, Color statusColor) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.restore_outlined, color: statusColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(date, style: AppTextStyles.body.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Text(
            status,
            style: AppTextStyles.body.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
