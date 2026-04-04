import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';
import '../utils/size_utils.dart';
import '../widgets/button_widget.dart';
import '../cubit/permission_cubit.dart';
import '../cubit/permission_state.dart';

class PermissionScreen extends StatelessWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionScreen({super.key, required this.onPermissionsGranted});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionCubit()..checkPermissions(),
      child: PermissionScreenView(onPermissionsGranted: onPermissionsGranted),
    );
  }
}

class PermissionScreenView extends StatelessWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionScreenView({super.key, required this.onPermissionsGranted});

  @override
  Widget build(BuildContext context) {
    return PermissionScreenContent(onPermissionsGranted: onPermissionsGranted);
  }
}

class PermissionScreenContent extends StatelessWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionScreenContent({super.key, required this.onPermissionsGranted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<PermissionCubit, PermissionState>(
          builder: (context, state) {
            if (state is PermissionChecking) {
              return _buildLoadingState();
            }

            bool isCameraGranted = false;
            bool isMicrophoneGranted = false;
            CameraController? cameraController;

            if (state is PermissionStatusUpdated) {
              isCameraGranted = state.isCameraGranted;
              isMicrophoneGranted = state.isMicrophoneGranted;
              cameraController = state.cameraController;
            }

            return SingleChildScrollView(
              padding: SizeUtils.scaffoldPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppConstants.largeVerticalSpace,
                  _buildHeader(),
                  AppConstants.extraLargeVerticalSpace,
                  _buildPermissionCards(context, isCameraGranted, isMicrophoneGranted),
                  AppConstants.extraLargeVerticalSpace,
                  _buildPreviewArea(cameraController, isCameraGranted),
                  AppConstants.extraLargeVerticalSpace,
                  _buildContinueButton(context, isCameraGranted, isMicrophoneGranted),
                  AppConstants.mediumVerticalSpace,
                  _buildPrivacyNote(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          AppConstants.mediumVerticalSpace,
          Text(
            'Checking permissions...',
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to join?',
          style: AppTextStyles.displayLarge(color: AppColors.textPrimary, fontWeight: FontWeight.w900),
        ),
        AppConstants.mediumVerticalSpace,
        Text(
          'To provide the best video and audio quality, we need your permission to access your camera and microphone.',
          style: AppTextStyles.labelLarge(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPermissionCards(BuildContext context, bool isCameraGranted, bool isMicrophoneGranted) {
    return Column(
      children: [
        _buildPermissionCard(
          context: context,
          icon: Icons.videocam,
          iconColor: AppColors.primary,
          title: 'Camera Access',
          description: 'Required for high-definition video broadcasting. Your feed is encrypted end-to-end.',
          isGranted: isCameraGranted,
          onTap: () => context.read<PermissionCubit>().requestCameraPermission(),
          buttonText: 'Allow Camera Access',
        ),
        AppConstants.mediumVerticalSpace,
        _buildPermissionCard(
          context: context,
          icon: Icons.mic,
          iconColor: AppColors.success,
          title: 'Microphone Access',
          description: 'Enables high-fidelity audio and active noise cancellation during your call.',
          isGranted: isMicrophoneGranted,
          onTap: () => context.read<PermissionCubit>().requestMicrophonePermission(),
          buttonText: 'Allow Microphone Access',
        ),
      ],
    );
  }

  Widget _buildPermissionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onTap,
    required String buttonText,
  }) {
    return Container(
      padding: SizeUtils.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius12),
        border: Border.all(color: isGranted ? iconColor.withOpacity(0.3) : AppColors.border, width: isGranted ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(SizeUtils.spacing8),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius12)),
                child: Icon(icon, color: iconColor, size: SizeUtils.getWidth(22)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing4),
                decoration: BoxDecoration(
                  color: isGranted ? AppColors.success.withOpacity(0.2) : AppColors.error.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(SizeUtils.radius8),
                ),
                child: Text(
                  isGranted ? 'GRANTED' : 'REQUIRED',
                  style: AppTextStyles.labelSmall(color: isGranted ? AppColors.success : AppColors.error, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          AppConstants.mediumVerticalSpace,
          Text(
            title,
            style: AppTextStyles.titleLarge(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          ),
          AppConstants.smallVerticalSpace,
          Text(
            description,
            style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontWeight: FontWeight.w400),
          ),
          AppConstants.mediumVerticalSpace,
          if (!isGranted)
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: buttonText,
                onPressed: onTap,
                icon: Icons.check_circle_outline,
                iconPosition: IconPosition.right,
                iconSize: 20,
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: SizeUtils.spacing12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SizeUtils.radius8),
                border: Border.all(color: AppColors.success),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: SizeUtils.getWidth(20)),
                  AppConstants.smallHorizontalSpace,
                  Text(
                    'Permission Granted',
                    style: AppTextStyles.bodyMedium(color: AppColors.success, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviewArea(CameraController? cameraController, bool isCameraGranted) {
    return Container(
      height: SizeUtils.getHeight(300),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(SizeUtils.radius12),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeUtils.radius12),
        child: Stack(
          children: [
            // Camera Preview or Placeholder
            if (cameraController != null && cameraController.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: cameraController.value.previewSize!.height,
                    height: cameraController.value.previewSize!.width,
                    child: CameraPreview(cameraController),
                  ),
                ),
              )
            else
              _buildPlaceholder(isCameraGranted),

            // Status Badge
            Positioned(
              top: SizeUtils.spacing16,
              left: SizeUtils.spacing16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing6),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(SizeUtils.radius8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: SizeUtils.getWidth(8),
                      height: SizeUtils.getWidth(8),
                      decoration: BoxDecoration(color: isCameraGranted ? AppColors.success : AppColors.error, shape: BoxShape.circle),
                    ),
                    AppConstants.smallHorizontalSpace,
                    Text(
                      isCameraGranted ? 'LIVE PREVIEW' : 'OFFLINE PREVIEW',
                      style: AppTextStyles.labelSmall(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),

            // Control Bar
            Positioned(
              bottom: SizeUtils.spacing16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(SizeUtils.spacing8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(SizeUtils.radius8),
                    border: Border.all(color: AppColors.border.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildControlIcon(Icons.mic_off),
                      AppConstants.smallHorizontalSpace,
                      _buildControlIcon(isCameraGranted ? Icons.videocam : Icons.videocam_off),
                      AppConstants.smallHorizontalSpace,
                      _buildControlIcon(Icons.blur_on),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isCameraGranted) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeUtils.getWidth(80),
            height: SizeUtils.getWidth(80),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 2, style: BorderStyle.solid),
            ),
            child: Icon(Icons.videocam_off, color: AppColors.textSecondary, size: SizeUtils.getWidth(40)),
          ),
          AppConstants.mediumVerticalSpace,
          Text(
            isCameraGranted ? 'Initializing camera...' : 'Waiting for camera permission...',
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildControlIcon(IconData icon) {
    return Container(
      width: SizeUtils.getWidth(40),
      height: SizeUtils.getWidth(40),
      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(SizeUtils.radius8)),
      child: Icon(icon, color: AppColors.textSecondary, size: SizeUtils.getWidth(20)),
    );
  }

  Widget _buildContinueButton(BuildContext context, bool isCameraGranted, bool isMicrophoneGranted) {
    final bool canContinue = isCameraGranted && isMicrophoneGranted;

    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: 'Enter Meeting Space',
        onPressed: canContinue
            ? () async {
                final cubit = context.read<PermissionCubit>();
                await cubit.disposeCamera();
                onPermissionsGranted();
              }
            : () {},
        isEnabled: canContinue,
        icon: Icons.rocket_launch,
        iconPosition: IconPosition.left,
        iconSize: 24,
      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'By entering, you agree to our ',
          style: AppTextStyles.bodySmall(color: AppColors.textSecondary.withOpacity(0.6), fontWeight: FontWeight.w400),
          children: [
            TextSpan(
              text: 'Privacy Policy',
              style: AppTextStyles.bodySmall(color: AppColors.primary, fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: ' regarding temporary media processing.',
              style: AppTextStyles.bodySmall(color: AppColors.textSecondary.withOpacity(0.6), fontWeight: FontWeight.w400),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
