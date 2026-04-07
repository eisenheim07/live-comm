import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';
import '../utils/size_utils.dart';
import '../widgets/error_bottom_sheet.dart';
import '../cubit/streaming_cubit.dart';
import '../cubit/streaming_state.dart';
import 'dashboard_screen.dart';

class StreamingScreen extends StatefulWidget {
  final String appId;
  final String channelName;
  final String token;

  const StreamingScreen({super.key, required this.appId, required this.channelName, required this.token});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  late final StreamingCubit _cubit;
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _cubit = StreamingCubit();
    // Hide status bar for immersive streaming experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Initialize Agora immediately since permissions are already granted
    _cubit.initializeAgora(appId: widget.appId, channelName: widget.channelName, token: widget.token);
  }

  @override
  void dispose() {
    // Restore status bar when leaving streaming screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _cubit.dispose();
    _cubit.close();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _cubit.engine?.muteLocalAudioStream(_isMuted);
    });
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOff = !_isCameraOff;
      _cubit.engine?.muteLocalVideoStream(_isCameraOff);
    });
  }

  void _switchCamera() {
    _cubit.engine?.switchCamera();
  }

  Future<void> _endStream() async {
    try {
      await _cubit.leaveChannel();
    } catch (e) {
      // Ignore errors during cleanup
    }

    // Always navigate back regardless of leave channel result
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StreamingCubit, StreamingState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is StreamingError) {
          ErrorBottomSheet.showError(context: context, title: 'Streaming Error', message: state.message, buttonText: 'Got it');
        } else if (state is StreamingDisconnected) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(StreamingState state) {
    if (state is StreamingConnecting) {
      return _buildConnectingState();
    } else if (state is StreamingConnected) {
      return _buildStreamingView();
    } else {
      return _buildInitialState();
    }
  }

  Widget _buildConnectingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          AppConstants.mediumVerticalSpace,
          Text(
            'Connecting to stream...',
            style: AppTextStyles.bodyMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off, size: SizeUtils.getWidth(64), color: AppColors.textSecondary),
          AppConstants.mediumVerticalSpace,
          Text(
            'Initializing...',
            style: AppTextStyles.bodyMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamingView() {
    return GestureDetector(
      onTap: _toggleControls,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          // Main video view
          _buildVideoView(),

          // Top bar with channel info - always in widget tree for animation
          _buildTopBar(),

          // Bottom controls - always in widget tree for animation
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildVideoView() {
    if (_cubit.engine == null) {
      return Container(
        color: AppColors.background,
        child: Center(
          child: Text('Camera not available', style: AppTextStyles.bodyMedium(color: AppColors.textSecondary)),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController(rtcEngine: _cubit.engine!, canvas: const VideoCanvas(uid: 0)),
    );
  }

  Widget _buildTopBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _showControls ? 0 : -100,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: EdgeInsets.all(SizeUtils.spacing16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.background.withOpacity(0.8), AppColors.background.withOpacity(0.0)],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing8, vertical: SizeUtils.spacing4),
                decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(SizeUtils.radius4)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: SizeUtils.getWidth(8),
                      height: SizeUtils.getWidth(8),
                      decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                    ),
                    AppConstants.smallHorizontalSpace,
                    Text(
                      'LIVE',
                      style: AppTextStyles.bodySmall(color: AppColors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              AppConstants.mediumHorizontalSpace,
              Expanded(
                child: Text(
                  widget.channelName,
                  style: AppTextStyles.bodyMedium(color: AppColors.white, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: _showControls ? 0 : -150,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: EdgeInsets.all(SizeUtils.spacing24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [AppColors.background.withOpacity(0.9), AppColors.background.withOpacity(0.0)],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(icon: _isMuted ? Icons.mic_off : Icons.mic, onPressed: _toggleMute, isActive: !_isMuted),
              _buildControlButton(icon: _isCameraOff ? Icons.videocam_off : Icons.videocam, onPressed: _toggleCamera, isActive: !_isCameraOff),
              _buildControlButton(icon: Icons.flip_camera_ios, onPressed: _switchCamera, isActive: true),
              _buildControlButton(icon: Icons.call_end, onPressed: _endStream, isActive: false, isDanger: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onPressed, required bool isActive, bool isDanger = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: SizeUtils.getWidth(56),
        height: SizeUtils.getWidth(56),
        decoration: BoxDecoration(
          color: isDanger
              ? AppColors.error
              : isActive
              ? AppColors.primary
              : AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDanger
                ? AppColors.error
                : isActive
                ? AppColors.primary
                : AppColors.border,
            width: 2,
          ),
        ),
        child: Icon(icon, color: isDanger || isActive ? AppColors.white : AppColors.textSecondary, size: SizeUtils.getWidth(24)),
      ),
    );
  }
}
