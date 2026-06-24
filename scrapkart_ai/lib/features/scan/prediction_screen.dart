import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/animated_blob_background.dart';

class PredictionScreen extends StatelessWidget {
  final Map<String, dynamic>? scanResult;
  const PredictionScreen({super.key, this.scanResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Prediction', style: AppTextStyles.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedBlobBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 60,
            left: 24,
            right: 24,
            bottom: 24,
          ),
          child: Column(
            children: [
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.recycling, size: 40, color: AppColors.secondary),
                    ),
                    const SizedBox(height: 16),
                    Text(scanResult != null ? scanResult!['material'].toString() : 'Plastic Bottle (PET)', style: AppTextStyles.headline.copyWith(fontSize: 22)),
                    const SizedBox(height: 8),
                    Text('Estimated Weight: ~${scanResult != null ? scanResult!['weight'].toString() : '0.5'} kg', style: AppTextStyles.body),
                  ],
                ),
              ).animate().slideY(begin: 0.2).fadeIn(),
              
              const SizedBox(height: 24),
              
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Estimated Value', style: AppTextStyles.title),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('₹${scanResult != null ? scanResult!['estimatedPrice'].toString() : '12'}', style: AppTextStyles.headline.copyWith(fontSize: 48, color: AppColors.primary)),
                        if (scanResult == null)
                          Text(' - ₹15', style: AppTextStyles.headline.copyWith(fontSize: 32, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Mock Graph Layout
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text('Market Trend Chart \n(Prices are up by 2%)', 
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.tertiary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            scanResult != null 
                              ? 'AI suggests selling now as prices are currently favorable.' 
                              : 'AI suggests selling now as plastic prices are currently high in your area.',
                            style: AppTextStyles.body.copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.2).fadeIn(delay: 200.ms),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Semantics(
                  button: true,
                  label: 'Confirm Booking Button',
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/tracking');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text('Confirm Booking', style: AppTextStyles.button),
                  ),
                ),
              ).animate().scale(delay: 400.ms).fadeIn(delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
