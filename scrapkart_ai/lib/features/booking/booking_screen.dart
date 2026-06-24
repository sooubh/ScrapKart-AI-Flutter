import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/widgets/animated_blob_background.dart';
import '../../core/widgets/glass_card.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<String> _selectedTypes = [];
  final List<String> _scrapTypes = ['Paper / Cardboard', 'Plastics', 'E-Waste', 'Glass', 'Metals'];

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitBooking() async {
    if (_selectedTypes.isEmpty || _weightController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill scrap type, weight, and address.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      // Save data directly to Firestore "bookings" collection
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user?.uid ?? 'anonymous', // Connects to the logged in user
        'email': user?.email ?? 'Unknown',
        'scrapTypes': _selectedTypes,
        'estimatedWeight': _weightController.text,
        'pickupAddress': _addressController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scrap Pickup Booked Successfully! 🎉')),
        );
        // Navigate to tracking screen
        context.push('/tracking');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Pickup', style: AppTextStyles.title),
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
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scrap Details', style: AppTextStyles.headline.copyWith(fontSize: 24))
                    .animate().slideX(begin: -0.2).fadeIn(),
                const SizedBox(height: 24),
                
                // Scrap Types (Multiple Selection)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _scrapTypes.map((type) {
                    final isSelected = _selectedTypes.contains(type);
                    return FilterChip(
                      label: Text(type, style: AppTextStyles.body.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 14,
                      )),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? AppColors.primary : Colors.white)
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedTypes.add(type);
                          } else {
                            _selectedTypes.remove(type);
                          }
                        });
                      },
                    );
                  }).toList(),
                ).animate().slideY(begin: 0.2).fadeIn(delay: 100.ms),
                const SizedBox(height: 16),
                
                // Weight
                _buildTextField(
                  controller: _weightController,
                  hint: 'Estimated Weight (kg)',
                  icon: Icons.monitor_weight_rounded,
                  keyboardType: TextInputType.number,
                ).animate().slideY(begin: 0.2).fadeIn(delay: 200.ms),
                const SizedBox(height: 16),
                
                // Pickup Address
                _buildTextField(
                  controller: _addressController,
                  hint: 'Pickup Address',
                  icon: Icons.location_on_rounded,
                  maxLines: 2,
                ).animate().slideY(begin: 0.2).fadeIn(delay: 300.ms),
                const SizedBox(height: 16),
                
                // Date & Time
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _dateController,
                        hint: 'Date',
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _timeController,
                        hint: 'Time',
                        icon: Icons.access_time_rounded,
                      ),
                    ),
                  ],
                ).animate().slideY(begin: 0.2).fadeIn(delay: 400.ms),
                
                const SizedBox(height: 40),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Schedule Pickup', style: AppTextStyles.button),
                  ),
                ).animate().scale(delay: 500.ms).fadeIn(delay: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint, 
    required IconData icon, 
    TextEditingController? controller,
    TextInputType? keyboardType, 
    int maxLines = 1
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.body,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint, 
    required IconData icon, 
    required String? value, 
    required List<String> items, 
    required void Function(dynamic) onChanged
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(hint, style: AppTextStyles.body),
            ],
          ),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          isExpanded: true,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(item, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
