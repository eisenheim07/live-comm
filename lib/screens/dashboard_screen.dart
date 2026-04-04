import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livecomm/screens/streaming_screen.dart';
import 'package:livecomm/widgets/button_widget.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  static const String _appId = AppConstants.agoraId;
  static const String _token = AppConstants.agoraToken;
  static const String _channelName = AppConstants.agoraChannelName;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _startStreaming() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamingScreen(appId: _appId, channelName: _channelName, token: _token),
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
