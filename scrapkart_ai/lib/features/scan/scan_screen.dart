import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/widgets/glass_card.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isScanned = false;
  bool _isScanning = false;
  
  File? _imageFile;
  Map<String, dynamic>? _scanResult;
  String _detectedItem = 'Unknown';
  String _matchPercentage = 'Wait...';
  String _suggestedCategory = '-';

  Future<void> _pickAndAnalyzeImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    
    if (pickedFile == null) return;

    setState(() {
      _isScanning = true;
      _isScanned = false;
      _imageFile = File(pickedFile.path);
    });

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate network request
      
      // Dummy Response for Testing
      final data = {
        'material': 'DUMMY_PLASTIC_BOTTLE (PET)',
        'conditionFactor': 0.85,
        'estimatedPricePerKg': 15,
      };

      _scanResult = data;
      _detectedItem = data['material']?.toString() ?? 'Unknown';
      _matchPercentage = '${(((data['conditionFactor'] as num?) ?? 0.5) * 100).toInt()}% Confident';
      _suggestedCategory = 'Recyclable Plastics';

      if (mounted) {
        setState(() {
          _isScanned = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AI Vision Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            'Gemini AI Vision',
            style: AppTextStyles.headline,
          ).animate().slideY(begin: -0.2).fadeIn(),
          const SizedBox(height: 8),
          Text(
            'Upload scrap to analyze material instantly',
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ).animate().slideY(begin: -0.2).fadeIn(delay: 100.ms),
          
          const SizedBox(height: 40),
          
          // Upload Box
          GestureDetector(
            onTap: _isScanning ? null : _pickAndAnalyzeImage,
            child: GlassCard(
              height: 300,
              padding: const EdgeInsets.all(24),
              child: Center(
                child: _isScanning
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: AppColors.primary),
                          const SizedBox(height: 24),
                          Text('Gemini is analyzing...', style: AppTextStyles.title),
                        ],
                      ).animate().fadeIn()
                    : (_imageFile != null) 
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt_rounded, size: 60, color: AppColors.primary),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Tap to Upload Image',
                                style: AppTextStyles.title.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
              ),
            ),
          ).animate().scale(delay: 200.ms).fadeIn(delay: 200.ms),
          
          if (_isScanned) ...[
            const SizedBox(height: 40),
            
            // Result Card
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.recycling, color: AppColors.secondary),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Detected Item', style: AppTextStyles.body),
                              Text(_detectedItem, style: AppTextStyles.title.copyWith(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _matchPercentage,
                          style: AppTextStyles.body.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Suggested Category:', style: AppTextStyles.body),
                      Text(_suggestedCategory, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.2).fadeIn(),
            
            const SizedBox(height: 40),
            
            // Check Price Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_scanResult != null) {
                    context.push('/prediction', extra: _scanResult);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text('Get Price Estimate', style: AppTextStyles.button),
              ),
            ).animate().scale(delay: 200.ms).fadeIn(),
            
            const SizedBox(height: 80),
          ],
        ],
      ),
    );
  }
}
