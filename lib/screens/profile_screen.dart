import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../utils/configs.dart';
import '../widgets/button_widget.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/error_bottom_sheet.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/shimmer_widget.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ProfileCubit()..fetchProfile(), child: const ProfileScreenView());
  }
}

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Track which field is currently being edited
  String? _editingField;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFields(dynamic user) {
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
    _phoneController.text = user?.phone ?? '';
  }

  void _enableFieldEditing(String fieldName) {
    setState(() {
      _editingField = fieldName;
    });
  }

  void _disableAllEditing() {
    setState(() {
      _editingField = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          _populateFields(state.user);
        } else if (state is ProfileError) {
          final exception = state.exception;
          if (exception is ApiException) {
            ErrorBottomSheet.showError(context: context, title: exception.errorTitle, message: exception.displayMessage, buttonText: 'Got it');
          } else {
            ErrorBottomSheet.showError(context: context, title: 'Error!', message: state.message, buttonText: 'Got it');
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBarFactory.create(title: 'My Profile', showBackButton: true),
          body: GestureDetector(
            onTap: () {
              AppConstants.getCloseKeyboard(context);
              _disableAllEditing(); // Disable editing when tapping outside
            },
            child: SingleChildScrollView(padding: SizeUtils.scaffoldPaddingSmall, child: _buildBody(state, false, false)),
          ),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state, bool isEditing, bool isLoading) {
    // Show shimmer during initial loading or error states
    if (state is ProfileLoading || state is ProfileError) {
      return const ProfileShimmer();
    }

    // Show normal content for loaded state
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Header
        _buildProfileHeader(state),
        AppConstants.extraLargeVerticalSpace,

        // Profile Form (read-only)
        _buildProfileForm(),
      ],
    );
  }

  Widget _buildProfileHeader(ProfileState state) {
    String name = 'Loading...';
    String email = 'Loading...';
    String role = 'USER';

    if (state is ProfileLoaded) {
      name = state.user.name ?? 'User Name';
      email = state.user.email ?? 'user@example.com';
      role = state.user.role ?? 'USER';
    }

    return Center(
      child: Container(
        padding: SizeUtils.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              width: SizeUtils.getWidth(80),
              height: SizeUtils.getWidth(80),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 3),
              ),
              child: Icon(Icons.person, size: SizeUtils.getWidth(40), color: AppColors.primary),
            ),
            AppConstants.mediumVerticalSpace,

            // User Info
            Text(
              name,
              style: AppTextStyles.headlineSmall(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            AppConstants.smallVerticalSpace,
            Text(
              email,
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            AppConstants.smallVerticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing6),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius6)),
              child: Text(
                role.toUpperCase(),
                style: AppTextStyles.bodySmall(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Container(
      padding: SizeUtils.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: AppTextStyles.titleMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          AppConstants.largeVerticalSpace,

          // Name Field
          _buildFormField(
            controller: _nameController, 
            label: 'Full Name', 
            icon: Icons.person_outline,
            fieldName: 'name',
            isEditing: _editingField == 'name',
          ),
          AppConstants.mediumVerticalSpace,

          // Email Field
          _buildFormField(
            controller: _emailController, 
            label: 'Email Address', 
            icon: Icons.email_outlined,
            fieldName: 'email',
            isEditing: _editingField == 'email',
          ),
          AppConstants.mediumVerticalSpace,

          // Phone Field
          _buildFormField(
            controller: _phoneController, 
            label: 'Phone Number', 
            icon: Icons.phone_outlined,
            fieldName: 'phone',
            isEditing: _editingField == 'phone',
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller, 
    required String label, 
    required IconData icon,
    required String fieldName,
    required bool isEditing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
            AppConstants.smallHorizontalSpace,
            GestureDetector(
              onTap: () {
                if (isEditing) {
                  _disableAllEditing(); // If already editing, disable editing
                } else {
                  _enableFieldEditing(fieldName); // Enable editing for this field
                }
              },
              child: Container(
                padding: EdgeInsets.all(SizeUtils.spacing4),
                decoration: BoxDecoration(
                  color: isEditing 
                    ? AppColors.primary.withOpacity(0.2) 
                    : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SizeUtils.radius4),
                ),
                child: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  color: AppColors.primary,
                  size: SizeUtils.getWidth(14),
                ),
              ),
            ),
          ],
        ),
        AppConstants.smallVerticalSpace,
        TextField(
          controller: controller,
          enabled: isEditing,
          style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.white),
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
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing12),
          ),
        ),
      ],
    );
  }
}
