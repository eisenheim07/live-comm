import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livecomm/screens/dashboard_screen.dart';
import 'package:livecomm/utils/app_text_styles.dart';
import 'package:livecomm/utils/image_constants.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_constants.dart';
import '../widgets/button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: SingleChildScrollView(
        padding: SizeUtils.screenPadding,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - SizeUtils.screenPadding.vertical),
          child: Padding(
            padding: SizeUtils.scaffoldPaddingSmall,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Title
                Image.asset(ImageConstants.imgLogo, fit: BoxFit.cover),
                Text('Bazaar Live', style: AppTextStyles.displayLarge()),
                AppConstants.extraLargeVerticalSpace,
                // Login Card
                Container(
                  padding: SizeUtils.cardPadding,
                  decoration: AppConstants.cardDecoration,
                  child: Column(
                    children: [
                      Text('Welcome Back', style: AppTextStyles.labelLarge()),
                      AppConstants.largeVerticalSpace,
                      // Email Field
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          hintStyle: AppTextStyles.labelMedium(),
                          labelStyle: AppTextStyles.labelMedium(),
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
                        ),
                        style: AppTextStyles.labelMedium(),
                      ),
                      AppConstants.mediumVerticalSpace,
                      // Password Field
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          hintStyle: AppTextStyles.labelMedium(),
                          labelStyle: AppTextStyles.labelMedium(),
                          prefixIcon: Icon(Icons.lock_outlined, color: AppColors.textSecondary),
                        ),
                        style: AppTextStyles.labelMedium(),
                      ),
                      AppConstants.largeVerticalSpace,
                      // Login Button - Using our custom Primary Button
                      PrimaryButton(
                        text: 'Login',
                        icon: Icons.login,
                        iconPosition: IconPosition.right,
                        iconSize: 24,
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
                        },
                      ),
                      AppConstants.mediumVerticalSpace,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
