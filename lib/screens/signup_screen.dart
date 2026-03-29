import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../utils/image_constants.dart';
import '../widgets/button_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();

  // State variables
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isValid = false;
  String _selectedRole = 'buyer';

  // Error messages
  String? _fullNameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _shopNameError;
  String? _gstNumberError;

  @override
  void initState() {
    super.initState();
    // Hide status bar and navigation bar completely
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Add listeners to validate form and clear field-specific errors
    _fullNameController.addListener(_validateFullName);
    _emailController.addListener(_validateEmail);
    _phoneController.addListener(_validatePhone);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
    _shopNameController.addListener(_validateShopName);
    _gstNumberController.addListener(_validateGstNumber);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _shopNameController.dispose();
    _gstNumberController.dispose();
    super.dispose();
  }

  // Validation methods
  void _validateFullName() {
    setState(() {
      _fullNameError = null;
      _updateFormValidity();
    });
  }

  void _validateEmail() {
    setState(() {
      _emailError = null;
      _updateFormValidity();
    });
  }

  void _validatePhone() {
    setState(() {
      _phoneError = null;
      _updateFormValidity();
    });
  }

  void _validatePassword() {
    setState(() {
      _passwordError = null;
      _updateFormValidity();
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _confirmPasswordError = null;
      _updateFormValidity();
    });
  }

  void _validateShopName() {
    setState(() {
      _shopNameError = null;
      _updateFormValidity();
    });
  }

  void _validateGstNumber() {
    setState(() {
      _gstNumberError = null;
      _updateFormValidity();
    });
  }

  void _updateFormValidity() {
    _isValid =
        _isFullNameValid(_fullNameController.text) &&
        _isEmailValid(_emailController.text) &&
        _isPhoneValid(_phoneController.text) &&
        _isPasswordValid(_passwordController.text) &&
        _isConfirmPasswordValid(_confirmPasswordController.text) &&
        (_selectedRole == 'buyer' || (_isShopNameValid(_shopNameController.text) && _isGstNumberValid(_gstNumberController.text)));
  }

  // Individual field validation methods
  bool _isFullNameValid(String fullName) {
    if (fullName.isEmpty) return false;
    if (fullName.length > 30) return false;
    // Only alphabets and spaces
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegex.hasMatch(fullName);
  }

  bool _isEmailValid(String email) {
    if (email.isEmpty) return false;
    if (email.length > 30) return false;
    // Email regex pattern
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _isPhoneValid(String phone) {
    if (phone.isEmpty) return false;
    if (phone.length != 10) return false;
    // Only numeric
    final phoneRegex = RegExp(r'^[0-9]+$');
    return phoneRegex.hasMatch(phone);
  }

  bool _isPasswordValid(String password) {
    if (password.isEmpty) return false;
    if (password.length < 10 || password.length > 30) return false;

    // Check for 1 uppercase, 1 lowercase, 1 special character, 1 numeric
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }

  bool _isConfirmPasswordValid(String confirmPassword) {
    return confirmPassword.isNotEmpty && confirmPassword == _passwordController.text;
  }

  bool _isShopNameValid(String shopName) {
    if (_selectedRole == 'buyer') return true;
    if (shopName.isEmpty) return false;
    if (shopName.length > 20) return false;
    // Only alphabets and spaces
    final shopNameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return shopNameRegex.hasMatch(shopName);
  }

  bool _isGstNumberValid(String gstNumber) {
    if (_selectedRole == 'buyer') return true;
    if (gstNumber.isEmpty) return false;
    // GST number regex: 15 characters, format: 22AAAAA0000A1Z5
    final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    return gstRegex.hasMatch(gstNumber);
  }

  // Error display methods
  void _showFullNameError() {
    setState(() {
      final fullName = _fullNameController.text;
      if (fullName.isEmpty) {
        _fullNameError = 'Full name is required';
      } else if (fullName.length > 30) {
        _fullNameError = 'Full name cannot exceed 30 characters';
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(fullName)) {
        _fullNameError = 'Full name can only contain alphabets';
      }
    });
  }

  void _showEmailError() {
    setState(() {
      final email = _emailController.text;
      if (email.isEmpty) {
        _emailError = 'Email is required';
      } else if (email.length > 30) {
        _emailError = 'Email cannot exceed 30 characters';
      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
        _emailError = 'Please enter a valid email address';
      }
    });
  }

  void _showPhoneError() {
    setState(() {
      final phone = _phoneController.text;
      if (phone.isEmpty) {
        _phoneError = 'Phone number is required';
      } else if (phone.length != 10) {
        _phoneError = 'Phone number must be exactly 10 digits';
      } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
        _phoneError = 'Phone number can only contain digits';
      }
    });
  }

  void _showPasswordError() {
    setState(() {
      final password = _passwordController.text;
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (password.length < 10) {
        _passwordError = 'Password must be at least 10 characters';
      } else if (password.length > 30) {
        _passwordError = 'Password cannot exceed 30 characters';
      } else {
        final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
        final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
        final hasDigit = RegExp(r'[0-9]').hasMatch(password);
        final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

        if (!hasUppercase) {
          _passwordError = 'Password must contain at least 1 uppercase letter';
        } else if (!hasLowercase) {
          _passwordError = 'Password must contain at least 1 lowercase letter';
        } else if (!hasDigit) {
          _passwordError = 'Password must contain at least 1 digit';
        } else if (!hasSpecialChar) {
          _passwordError = 'Password must contain at least 1 special character';
        }
      }
    });
  }

  void _showConfirmPasswordError() {
    setState(() {
      final confirmPassword = _confirmPasswordController.text;
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Confirm password is required';
      } else if (confirmPassword != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      }
    });
  }

  void _showShopNameError() {
    if (_selectedRole == 'buyer') return;
    setState(() {
      final shopName = _shopNameController.text;
      if (shopName.isEmpty) {
        _shopNameError = 'Shop name is required';
      } else if (shopName.length > 20) {
        _shopNameError = 'Shop name cannot exceed 20 characters';
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(shopName)) {
        _shopNameError = 'Shop name can only contain alphabets';
      }
    });
  }

  void _showGstNumberError() {
    if (_selectedRole == 'buyer') return;
    setState(() {
      final gstNumber = _gstNumberController.text;
      if (gstNumber.isEmpty) {
        _gstNumberError = 'GST number is required';
      } else if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$').hasMatch(gstNumber)) {
        _gstNumberError = 'Please enter a valid GST number';
      }
    });
  }

  void _clearEmail() {
    _emailController.clear();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _onRoleChanged(String? newRole) {
    setState(() {
      _selectedRole = newRole ?? 'buyer';
      // Clear seller-specific fields when switching to buyer
      if (_selectedRole == 'buyer') {
        _shopNameController.clear();
        _gstNumberController.clear();
        _shopNameError = null;
        _gstNumberError = null;
      }
      _updateFormValidity();
    });
  }

  void _handleSignUp() {
    // Always validate all fields and show errors when button is clicked
    bool hasError = false;

    // Validate all fields
    if (!_isFullNameValid(_fullNameController.text)) {
      _showFullNameError();
      hasError = true;
    }

    if (!_isEmailValid(_emailController.text)) {
      _showEmailError();
      hasError = true;
    }

    if (!_isPhoneValid(_phoneController.text)) {
      _showPhoneError();
      hasError = true;
    }

    if (!_isPasswordValid(_passwordController.text)) {
      _showPasswordError();
      hasError = true;
    }

    if (!_isConfirmPasswordValid(_confirmPasswordController.text)) {
      _showConfirmPasswordError();
      hasError = true;
    }

    if (_selectedRole == 'seller') {
      if (!_isShopNameValid(_shopNameController.text)) {
        _showShopNameError();
        hasError = true;
      }

      if (!_isGstNumberValid(_gstNumberController.text)) {
        _showGstNumberError();
        hasError = true;
      }
    }

    // Only proceed with signup if no validation errors
    if (!hasError) {
      // TODO: Implement signup API call
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign up functionality will be implemented'), backgroundColor: AppColors.success));
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
                  // Sign Up Card
                  Container(
                    padding: SizeUtils.cardPadding,
                    decoration: AppConstants.cardDecoration,
                    child: Column(
                      children: [
                        Text('Create Account', style: AppTextStyles.labelLarge()),
                        AppConstants.largeVerticalSpace,

                        // Full Name Field
                        _buildTextField(
                          controller: _fullNameController,
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: Icons.person_outlined,
                          errorText: _fullNameError,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), LengthLimitingTextInputFormatter(30)],
                        ),
                        AppConstants.mediumVerticalSpace,

                        // Email Field
                        _buildTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          errorText: _emailError,
                          suffixIcon: _emailController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: AppColors.white),
                                  onPressed: _clearEmail,
                                )
                              : null,
                          inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        ),
                        AppConstants.mediumVerticalSpace,

                        // Phone Field
                        _buildTextField(
                          controller: _phoneController,
                          labelText: 'Phone Number',
                          hintText: 'Enter your phone number',
                          prefixIcon: Icons.phone_outlined,
                          errorText: _phoneError,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        ),
                        AppConstants.mediumVerticalSpace,

                        // Password Field
                        _buildTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icons.lock_outlined,
                          errorText: _passwordError,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.white),
                            onPressed: _togglePasswordVisibility,
                          ),
                          inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        ),
                        AppConstants.mediumVerticalSpace,

                        // Confirm Password Field
                        _buildTextField(
                          controller: _confirmPasswordController,
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your password',
                          prefixIcon: Icons.lock_outlined,
                          errorText: _confirmPasswordError,
                          obscureText: !_isConfirmPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.white),
                            onPressed: _toggleConfirmPasswordVisibility,
                          ),
                          inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        ),
                        AppConstants.mediumVerticalSpace,

                        // Role Dropdown
                        _buildRoleDropdown(),
                        AppConstants.mediumVerticalSpace,

                        // Shop Name Field (conditional)
                        _buildTextField(
                          controller: _shopNameController,
                          labelText: 'Shop Name',
                          hintText: 'Enter your shop name',
                          prefixIcon: Icons.store_outlined,
                          errorText: _shopNameError,
                          enabled: _selectedRole == 'seller',
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), LengthLimitingTextInputFormatter(20)],
                        ),
                        AppConstants.mediumVerticalSpace,

                        // GST Number Field (conditional)
                        _buildTextField(
                          controller: _gstNumberController,
                          labelText: 'GST Number',
                          hintText: 'Enter your GST number',
                          prefixIcon: Icons.receipt_outlined,
                          errorText: _gstNumberError,
                          enabled: _selectedRole == 'seller',
                          inputFormatters: [LengthLimitingTextInputFormatter(15), FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]'))],
                        ),
                        AppConstants.largeVerticalSpace,

                        // Sign Up Button
                        PrimaryButton(
                          text: 'Sign Up',
                          icon: Icons.person_add,
                          iconPosition: IconPosition.right,
                          iconSize: 24,
                          isEnabled: _isValid,
                          onPressed: _handleSignUp, // Always allow clicking to show validation errors
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            hintStyle: AppTextStyles.labelMedium(color: enabled ? AppColors.white : AppColors.white.withOpacity(0.3)),
            labelStyle: AppTextStyles.labelMedium(color: enabled ? AppColors.white : AppColors.white.withOpacity(0.3)),
            prefixIcon: Icon(prefixIcon, color: enabled ? AppColors.white : AppColors.white.withOpacity(0.3)),
            suffixIcon: suffixIcon,
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeUtils.radius8),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
            ),
          ),
          style: AppTextStyles.labelMedium(color: enabled ? AppColors.textPrimary : AppColors.textPrimary.withOpacity(0.3)),
        ),
        // Error message
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: SizeUtils.spacing8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                errorText,
                style: AppTextStyles.bodySmall(color: AppColors.error, fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedRole,
          onChanged: _onRoleChanged,
          decoration: InputDecoration(
            labelText: 'Role',
            labelStyle: AppTextStyles.labelMedium(color: AppColors.white),
            prefixIcon: Icon(Icons.work_outlined, color: AppColors.white),
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
          dropdownColor: AppColors.surface,
          items: [
            DropdownMenuItem(
              value: 'buyer',
              child: Text('Buyer', style: AppTextStyles.labelMedium(color: AppColors.textPrimary)),
            ),
            DropdownMenuItem(
              value: 'seller',
              child: Text('Seller', style: AppTextStyles.labelMedium(color: AppColors.textPrimary)),
            ),
          ],
        ),
      ],
    );
  }
}
