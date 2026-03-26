import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import 'dashboard_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  Timer? _timer;
  int _remainingSeconds = 30;
  bool _isValid = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Hide status bar and navigation bar completely
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _startTimer();

    // Add listeners to all OTP controllers for validation
    for (int i = 0; i < _otpControllers.length; i++) {
      _otpControllers[i].addListener(_validateOtp);
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _validateOtp() {
    setState(() {
      // Clear error message when user starts typing
      _errorMessage = null;
      _isValid = _isOtpValid();
    });
  }

  bool _isOtpValid() {
    String otp = _getOtpString();
    if (otp.length != 6) return false;

    // Check if all characters are digits
    final otpRegex = RegExp(r'^[0-9]{6}$');
    return otpRegex.hasMatch(otp);
  }

  String _getOtpString() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _showErrorMessage() {
    setState(() {
      String otp = _getOtpString();
      if (otp.isEmpty) {
        _errorMessage = 'OTP is required';
      } else if (otp.length < 6) {
        _errorMessage = 'Please enter complete 6-digit OTP';
      } else if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
        _errorMessage = 'OTP must contain only digits';
      } else {
        _errorMessage = 'Please enter a valid 6-digit OTP';
      }
    });
  }

  void _handleVerifyOtp() {
    if (_isValid) {
      // Navigate to dashboard
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
    } else {
      _showErrorMessage();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
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

              // Title
              Text(
                'Verify your number',
                style: AppTextStyles.headlineLarge(color: AppColors.textHeading, fontWeight: FontWeight.w600),
              ),
              AppConstants.smallVerticalSpace,

              // Subtitle with phone number
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                  children: [
                    const TextSpan(text: 'OTP sent to '),
                    TextSpan(
                      text: '+91 98765 43210',
                      style: AppTextStyles.bodyMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              AppConstants.extraLargeVerticalSpace,

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: SizeUtils.getWidth(45),
                    height: SizeUtils.getHeight(50),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppConstants.smallRadius,
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
                      style: AppTextStyles.headlineMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
                      onChanged: (value) {
                        setState(() {
                          _onOtpChanged(value, index);
                        });
                      },
                    ),
                  );
                }),
              ),

              // Error message display
              if (_errorMessage != null)
                Padding(
                  padding: SizeUtils.screenPadding,
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.bodySmall(color: AppColors.error, fontWeight: FontWeight.w500),
                  ),
                ),

              AppConstants.largeVerticalSpace,

              // Resend OTP section
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                    children: [
                      const TextSpan(text: 'Didn\'t receive OTP ? '),
                      if (_remainingSeconds > 0) ...[
                        TextSpan(
                          text: 'Resend in ${_remainingSeconds}s',
                          style: AppTextStyles.bodyMedium(color: AppColors.primary, fontWeight: FontWeight.w500),
                        ),
                      ] else ...[
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _remainingSeconds = 30;
                              });
                              _startTimer();
                            },
                            child: Text(
                              'Resend',
                              style: AppTextStyles.bodyMedium(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ).copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Spacer to push button to bottom
              const Spacer(),

              // Verify & Continue Button
              PrimaryButton(text: 'Verify & Continue →', onPressed: _handleVerifyOtp, isEnabled: _isValid),
            ],
          ),
        ),
      ),
    );
  }
}
