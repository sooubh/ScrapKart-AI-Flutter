import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/widgets/animated_blob_background.dart';
import '../../core/widgets/glass_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLoginMode = true; // Toggle between Login and Signup

  Future<void> _handleEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Authentication Error');
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      // Temporarily bypassed for fast compiling 
      _showError('Google Sign-In coming soon!');
      /*
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; 

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) context.go('/home');
      */
    } catch (e) {
      _showError('Google Sign In Failed: $e');
    }
  }

  Future<void> _signInWithPhone() async {
    String phoneNumber = '';
    
    // 1. Show Dialog to ask for phone number
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Phone Login', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: TextField(
          keyboardType: TextInputType.phone,
          onChanged: (val) => phoneNumber = val,
          decoration: const InputDecoration(
            hintText: '+91 9876543210 (include code)',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Send OTP', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (phoneNumber.trim().isEmpty) return;
    
    setState(() => _isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-resolution (on Android only)
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (mounted) context.go('/home');
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) setState(() => _isLoading = false);
        _showError(e.message ?? 'Phone Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) async {
        if (mounted) setState(() => _isLoading = false);
        String smsCode = '';
        
        // 2. Ask user for the fetched OTP
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Enter OTP', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (val) => smsCode = val,
              decoration: const InputDecoration(
                hintText: '123456',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 24, letterSpacing: 8),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Verify & Login', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );

        if (smsCode.trim().isNotEmpty) {
          setState(() => _isLoading = true);
          try {
            final PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, 
              smsCode: smsCode.trim()
            );
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (mounted) context.go('/home');
          } catch (e) {
            _showError('Invalid OTP!');
          } finally {
            if (mounted) setState(() => _isLoading = false);
          }
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
         if (mounted && _isLoading) setState(() => _isLoading = false);
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBlobBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isLoginMode ? 'Welcome Back 👋' : 'Create Account 🎉',
                style: AppTextStyles.headline.copyWith(fontSize: 32),
              ).animate().slideX(begin: -0.2, end: 0, duration: 500.ms).fadeIn(),
              const SizedBox(height: 8),
              Text(
                _isLoginMode ? 'Login to continue' : 'Sign up to get started with ScrapKart',
                style: AppTextStyles.subtitle,
              ).animate().slideX(begin: -0.2, end: 0, duration: 500.ms, delay: 100.ms).fadeIn(delay: 100.ms),
              
              const SizedBox(height: 48),
              
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      hint: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleEmailAuth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading 
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                _isLoginMode ? 'Login' : 'Sign Up', 
                                style: AppTextStyles.button
                              ),
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms).fadeIn(delay: 200.ms),
              
              const SizedBox(height: 32),
              
              Center(
                child: Text('Or continue with', style: AppTextStyles.body)
                    .animate().fadeIn(delay: 400.ms),
              ),
              
              const SizedBox(height: 24),
              
              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(Icons.g_mobiledata, AppColors.secondary, _signInWithGoogle),
                  const SizedBox(width: 16),
                  _buildSocialButton(Icons.phone, AppColors.tertiary, _signInWithPhone),
                ],
              ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 500.ms).fadeIn(delay: 500.ms),
              
              const SizedBox(height: 24),
              
              // Guest Access Option
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    context.go('/home'); // Route directly past auth wall
                  },
                  icon: const Icon(Icons.person_outline, color: Colors.blueAccent),
                  label: Text(
                    'Continue as Guest', 
                    style: AppTextStyles.body.copyWith(
                      color: Colors.blueAccent, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 550.ms).fadeIn(delay: 550.ms),

              const SizedBox(height: 40),
              
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLoginMode ? "Don't have an account? " : 'Already have an account? ', 
                      style: AppTextStyles.body
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLoginMode = !_isLoginMode;
                        });
                      },
                      child: Text(
                        _isLoginMode ? 'Sign Up' : 'Login',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint, 
    required IconData icon, 
    bool isPassword = false
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.body,
          prefixIcon: Icon(icon, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: IconButton(
        icon: Icon(icon, size: 38, color: color),
        onPressed: onTap,
      ),
    );
  }
}
