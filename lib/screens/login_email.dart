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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    // Hide status bar and navigation bar completely
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Add listeners to validate form
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isValid = _isEmailValid(_emailController.text) && _isPasswordValid(_passwordController.text);
    });
  }

  bool _isEmailValid(String email) {
    if (email.isEmpty) return false;
    if (email.length > 30) return false;

    // Email regex pattern
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    if (password.isEmpty) return false;
    if (password.length > 30) return false;
    return true;
  }

  void _clearEmail() {
    _emailController.clear();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () {
          // Close keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            hintStyle: AppTextStyles.labelMedium(color: AppColors.white),
                            labelStyle: AppTextStyles.labelMedium(color: AppColors.white),
                            prefixIcon: Icon(Icons.email_outlined, color: AppColors.white),
                            suffixIcon: _emailController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: AppColors.white),
                                    onPressed: _clearEmail,
                                  )
                                : null,
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
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            hintStyle: AppTextStyles.labelMedium(color: AppColors.white),
                            labelStyle: AppTextStyles.labelMedium(color: AppColors.white),
                            prefixIcon: Icon(Icons.lock_outlined, color: AppColors.white),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.white),
                              onPressed: _togglePasswordVisibility,
                            ),
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
                          isEnabled: _isValid,
                          onPressed: () {
                            _isValid ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen())) : null;
                          },
                        ),
                        AppConstants.mediumVerticalSpace,
                        // Login with OTP link
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginOtpScreen()));
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
      ),
    );
  }
}
