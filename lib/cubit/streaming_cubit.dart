import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../utils/app_logger.dart';
import 'streaming_state.dart';

class StreamingCubit extends Cubit<StreamingState> {
  RtcEngine? _engine;
  int? _uid;
  String? _channelName;

  StreamingCubit() : super(StreamingInitial());

  Future<void> requestPermissions() async {
    try {
      emit(StreamingPermissionRequesting());
      AppLogger.info('Requesting camera and microphone permissions');

      final cameraStatus = await Permission.camera.request();
      final microphoneStatus = await Permission.microphone.request();

      if (cameraStatus.isGranted && microphoneStatus.isGranted) {
        AppLogger.info('Permissions granted');
        emit(StreamingPermissionGranted());
      } else if (cameraStatus.isPermanentlyDenied || microphoneStatus.isPermanentlyDenied) {
        AppLogger.warning('Permissions permanently denied');
        emit(StreamingPermissionDenied('Camera or Microphone permission is permanently denied. Please enable it from settings.'));
      } else {
        AppLogger.warning('Permissions denied');
        emit(StreamingPermissionDenied('Camera and Microphone permissions are required to start streaming.'));
      }
    } catch (e) {
      AppLogger.error('Error requesting permissions', 'StreamingCubit', e);
      emit(StreamingError('Failed to request permissions: ${e.toString()}'));
    }
  }

  Future<void> initializeAgora({required String appId, required String channelName, required String token}) async {
    try {
      emit(StreamingConnecting());
      AppLogger.info('Initializing Agora Engine');

      _channelName = channelName;

      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(appId: appId, channelProfile: ChannelProfileType.channelProfileLiveBroadcasting));

      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine!.enableVideo();
      await _engine!.startPreview();

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            AppLogger.info('Successfully joined channel: ${connection.channelId}');
            _uid = connection.localUid;
            emit(StreamingConnected(_uid!, _channelName!));
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            AppLogger.info('Remote user joined: $remoteUid');
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            AppLogger.info('Remote user offline: $remoteUid');
          },
          onError: (ErrorCodeType err, String msg) {
            AppLogger.error('Agora Error: $err - $msg');
            emit(StreamingError('Streaming error: $msg'));
          },
        ),
      );

      await _engine!.joinChannel(token: token, channelId: channelName, uid: 0, options: const ChannelMediaOptions());

      AppLogger.info('Joined channel: $channelName');
    } catch (e) {
      AppLogger.error('Error initializing Agora', 'StreamingCubit', e);
      emit(StreamingError('Failed to initialize streaming: ${e.toString()}'));
    }
  }

  Future<void> leaveChannel() async {
    try {
      AppLogger.info('Leaving channel');
      await _engine?.leaveChannel();
    } catch (e) {
      AppLogger.error('Error leaving channel', 'StreamingCubit', e);
    } finally {
      // Always emit disconnected state regardless of errors
      emit(StreamingDisconnected());
    }
  }

  Future<void> dispose() async {
    try {
      await _engine?.leaveChannel();
      await _engine?.release();
      _engine = null;
    } catch (e) {
      AppLogger.error('Error disposing Agora engine', 'StreamingCubit', e);
    }
  }

  RtcEngine? get engine => _engine;

  int? get uid => _uid;

  String? get channelName => _channelName;
}
