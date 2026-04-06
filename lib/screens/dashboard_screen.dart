import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livecomm/widgets/custom_snackbar.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/button_widget.dart';
import '../cubit/live_session_cubit.dart';
import '../cubit/live_session_state.dart';

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

  _startStreaming() =>
      context.read<LiveSessionCubit>().createAndStartLiveSession(title: 'Live Shopping Session', thumbnail: 'https://example.com/thumbnail.jpg');

  Future<void> _navigateToStreaming(LiveSessionStarted state) async {
    if (!mounted) return;

    // TODO: Implement streaming functionality
    context.flushBarSuccessMessage(message: 'Live session started! Session ID: ${state.liveId}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LiveSessionCubit, LiveSessionState>(
      listener: (context, state) {
        if (state is LiveSessionError) {
          context.flushBarErrorMessage(message: state.message);
        } else if (state is LiveSessionStarted) {
          context.flushBarSuccessMessage(message: 'Live session started successfully!');
          _navigateToStreaming(state);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBarFactory.create(title: 'BazaarLive', showBackButton: false),
        body: Padding(
          padding: SizeUtils.scaffoldPaddingSmall,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<LiveSessionCubit, LiveSessionState>(
                builder: (context, state) {
                  final isLoading = state is LiveSessionCreating || state is LiveSessionStarting;

                  return PrimaryButton(
                    text: 'Start Streaming',
                    icon: Icons.video_call,
                    iconPosition: IconPosition.right,
                    iconSize: 24,
                    onPressed: isLoading ? () {} : _startStreaming,
                    isEnabled: !isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
