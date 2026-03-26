import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import 'verify_otp.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key});

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isValid = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Hide status bar and navigation bar completely
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Add listener to validate phone number
    _phoneController.addListener(_validatePhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone() {
    setState(() {
      // Clear error message when user starts typing
      _errorMessage = null;
      _isValid = _isPhoneValid(_phoneController.text);
    });
  }

  bool _isPhoneValid(String phone) {
    if (phone.isEmpty) return false;
    if (phone.length != 10) return false;

    // Check if all characters are digits
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }

  void _showErrorMessage() {
    setState(() {
      final phone = _phoneController.text;
      if (phone.isEmpty) {
        _errorMessage = 'Phone number is required';
      } else if (phone.length < 10) {
        _errorMessage = 'Phone number must be 10 digits';
      } else if (phone.length > 10) {
        _errorMessage = 'Phone number cannot exceed 10 digits';
      } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
        _errorMessage = 'Phone number must contain only digits';
      } else {
        _errorMessage = 'Please enter a valid 10-digit phone number';
      }
    });
  }

  void _handleSendOTP() {
    // Close keyboard when tapping outside
    AppConstants.getCloseKeyboard(context);
    if (_isValid) {
      // Navigate to verify OTP screen
      Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyOtpScreen()));
    } else {
      _showErrorMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Close keyboard when tapping outside
          AppConstants.getCloseKeyboard(context);
        },
        child: Padding(
          padding: SizeUtils.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.extraLargeVerticalSpace,
              AppConstants.extraLargeVerticalSpace,

              // Welcome emoji
              Text('👋', style: AppTextStyles.displayMedium(color: AppColors.textPrimary)),
              AppConstants.largeVerticalSpace,

              // Welcome title
              Text(
                'Welcome to BazaarLive',
                style: AppTextStyles.headlineMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              AppConstants.smallVerticalSpace,

              // Subtitle
              Text('Shop live from India\'s most iconic bazaars', style: AppTextStyles.labelSmall(color: AppColors.brown)),

              AppConstants.extraLargeVerticalSpace,

              // Enter mobile number label
              Text(
                'ENTER YOUR MOBILE NUMBER',
                style: AppTextStyles.labelSmall(color: AppColors.brown, fontWeight: FontWeight.w500),
              ),
              AppConstants.smallVerticalSpace,

              // Phone number input container
              Container(
                height: SizeUtils.getHeight(48),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppConstants.smallRadius,
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  children: [
                    // Country code section
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12),
                      child: Text(
                        '+91',
                        style: AppTextStyles.bodyMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                      ),
                    ),

                    // Vertical divider
                    Container(height: SizeUtils.spacing20, width: 1, color: AppColors.border),

                    // Phone number input field
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          hintText: '98765 43210',
                          hintStyle: AppTextStyles.bodyMedium(color: AppColors.textTertiary),
                          border: InputBorder.none,
                          counterText: '',
                          // Hide the character counter
                          contentPadding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Error message display
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: SizeUtils.spacing8),
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.bodySmall(color: AppColors.error, fontWeight: FontWeight.w500),
                  ),
                ),

              // Spacer to push button to bottom
              const Spacer(),

              // Send OTP Button using our custom PrimaryButton
              Column(
                children: [
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
                        children: [
                          const TextSpan(text: 'By continuing, you agree to our '),
                          TextSpan(
                            text: 'Terms & Privacy Policy',
                            style: AppTextStyles.bodySmall(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppConstants.smallVerticalSpace,
                  PrimaryButton(text: 'Send OTP →', onPressed: _handleSendOTP, isEnabled: _isValid),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
