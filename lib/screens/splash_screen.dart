import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/image_constants.dart';
import '../utils/app_constants.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import 'login_email.dart';
import 'main_navigation_screen.dart';
import 'permission_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashPermissionsGranted) {
          // Permissions granted - navigate to main navigation (dashboard)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          );
        } else if (state is SplashPermissionsDenied) {
          // Permissions denied - navigate to permission screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PermissionScreen(
                onPermissionsGranted: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                  );
                },
              ),
            ),
          );
        } else if (state is SplashUnauthenticated) {
          // User is not authenticated - navigate to login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
      child: const SplashScreenView(),
    );
  }
}

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    // Hide status bar and navigation bar completely
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
            Image.asset(ImageConstants.imgLogo, fit: BoxFit.cover),
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