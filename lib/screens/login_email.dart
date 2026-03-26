import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livecomm/screens/dashboard_screen.dart';
import 'package:livecomm/screens/login_otp.dart';
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

  late var _isValid = false;

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
                          hintStyle: AppTextStyles.labelMedium(color: AppColors.white),
                          labelStyle: AppTextStyles.labelMedium(color: AppColors.white),
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(SizeUtils.radius8),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(SizeUtils.radius8),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(SizeUtils.radius8),
                            borderSide: BorderSide(color: AppColors.white),
                          ),
                        ),
                        style: AppTextStyles.labelMedium(color: AppColors.textPrimary),
                      ),
                      AppConstants.mediumVerticalSpace,
                      // Password Field
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          hintStyle: AppTextStyles.labelMedium(color: AppColors.white),
                          labelStyle: AppTextStyles.labelMedium(color: AppColors.white),
                          prefixIcon: Icon(Icons.lock_outlined, color: AppColors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(SizeUtils.radius8),
                            borderSide: BorderSide(color: AppColors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(SizeUtils.radius8),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(SizeUtils.radius8),
                            borderSide: BorderSide(color: AppColors.white),
                          ),
                        ),
                        style: AppTextStyles.labelMedium(color: AppColors.textPrimary),
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
                        isEnabled: _isValid,
                      ),
                      AppConstants.mediumVerticalSpace,
                      // Login with OTP link
                      GestureDetector(
                        onTap: () {
                          _isValid ? Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginOtpScreen())) : null;
                        },
                        child: Text(
                          'Login with OTP',
                          style: AppTextStyles.labelMedium(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.white),
                        ),
                      ),
                      AppConstants.smallVerticalSpace,
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
