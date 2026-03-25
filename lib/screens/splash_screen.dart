import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/image_constants.dart';
import '../utils/app_constants.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Hide status bar and navigation bar completely
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _navigateToLogin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToLogin() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(ImageConstants.logo, fit: BoxFit.cover),
            AppConstants.extraLargeVerticalSpace,
            // App Name
            Text(
              'BazaarLive',
              style: AppTextStyles.displayMedium(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            AppConstants.smallVerticalSpace,
            // Tagline
            Text('India\'s Biggest Live Bazaars.', style: AppTextStyles.bodyMedium(color: AppColors.primary)),
            AppConstants.extraLargeVerticalSpace,
            AppConstants.extraLargeVerticalSpace,
            // Loading indicator
            AppConstants.primaryLoader,
          ],
        ),
      ),
    );
  }
}
