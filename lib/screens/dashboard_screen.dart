import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livecomm/utils/app_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:livecomm/screens/streaming_screen.dart';
import 'package:livecomm/widgets/button_widget.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../widgets/custom_app_bar.dart';
import 'permission_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _startStreaming() async {
    // Check permissions before starting streaming
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;

    if (!mounted) return;

    if (!cameraStatus.isGranted || !microphoneStatus.isGranted) {
      // Permissions not granted - navigate to permission screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PermissionScreen(
            onPermissionsGranted: () {
              Navigator.pop(context);
              _navigateToStreaming();
            },
          ),
        ),
      );
    } else {
      // Permissions already granted - start streaming
      _navigateToStreaming();
    }
  }

  void _navigateToStreaming() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StreamingScreen(appId: AppConstants.agoraId, channelName: AppConstants.agoraChannelName, token: AppConstants.agoraToken),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarFactory.create(title: 'BazaarLive', showBackButton: false),
      body: Padding(
        padding: SizeUtils.scaffoldPaddingSmall,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              text: 'Start Streaming',
              icon: Icons.video_call,
              iconPosition: IconPosition.right,
              iconSize: 24,
              onPressed: _startStreaming,
            ),
          ],
        ),
      ),
    );
  }
}
