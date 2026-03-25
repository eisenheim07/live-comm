import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import 'dashboard_screen.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key});

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Hide status bar and navigation bar completely
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
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
            Text('Shop live from India\'s most iconic bazaars', style: AppTextStyles.bodyMedium(color: AppColors.brown)),

            AppConstants.extraLargeVerticalSpace,

            // Enter mobile number label
            Text(
              'ENTER YOUR MOBILE NUMBER',
              style: AppTextStyles.labelSmall(color: AppColors.textTertiary, fontWeight: FontWeight.w500),
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
                      style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: '98765 43210',
                        hintStyle: AppTextStyles.bodyMedium(color: AppColors.textTertiary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AppConstants.smallVerticalSpace,

            // Terms and privacy text
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

            // Spacer to push button to bottom
            const Spacer(),

            // Send OTP Button using our custom PrimaryButton
            SecondaryButton(
              text: 'Send OTP →',
              onPressed: () {
                // Navigate to dashboard for now
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
