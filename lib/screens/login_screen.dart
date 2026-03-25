import 'package:flutter/material.dart';
import 'package:livecomm/utils/app_text_styles.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: SizeUtils.screenPadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  SizeUtils.screenPadding.vertical,
            ),
            child: Padding(
              padding: SizeUtils.cardPaddingSmall,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Title
                  Text('Bazaar Live', style: AppTextStyles.displayLarge()),
                  AppConstants.smallVerticalSpace,
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
                            // Add login logic here
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
      ),
    );
  }
}
