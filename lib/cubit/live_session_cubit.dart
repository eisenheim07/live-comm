import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/app_repository.dart';
import '../utils/app_logger.dart';
import 'live_session_state.dart';

class LiveSessionCubit extends Cubit<LiveSessionState> {
  final AppRepository _repository;

  LiveSessionCubit(this._repository) : super(const LiveSessionInitial());

  /// Create and start a live session
  Future<void> createAndStartLiveSession({required String title, String? thumbnail}) async {
    try {
      emit(const LiveSessionCreating());
      AppLogger.info('Creating live session: $title', 'LiveSession');

      // Step 1: Create live session
      final createResponse = await _repository.createLiveSession(title: title, startTime: DateTime.now(), thumbnail: thumbnail);

      if (createResponse['success'] != true) {
        final errorMessage = createResponse['message'] ?? 'Failed to create live session';
        AppLogger.error('Failed to create live session', 'LiveSession', errorMessage);
        emit(LiveSessionError(errorMessage));
        return;
      }

      final liveData = createResponse['data'];
      final liveId = liveData['_id'] as String;

      AppLogger.success('Live session created: $liveId', 'LiveSession');
      emit(LiveSessionCreated(liveId: liveId, title: title));

      // Step 2: Start the live session immediately
      await _startLiveSession(liveId, title);
    } catch (e) {
      AppLogger.error('Error creating live session', 'LiveSession', e);
      emit(LiveSessionError('Failed to create live session: ${e.toString()}'));
    }
  }

  /// Start an existing live session
  Future<void> _startLiveSession(String liveId, String title) async {
    try {
      emit(LiveSessionStarting(liveId));
      AppLogger.info('Starting live session: $liveId', 'LiveSession');

      final startResponse = await _repository.startLiveSession(liveId);

      if (startResponse['success'] != true) {
        final errorMessage = startResponse['message'] ?? 'Failed to start live session';
        AppLogger.error('Failed to start live session', 'LiveSession', errorMessage);
        emit(LiveSessionError(errorMessage));
        return;
      }

      final liveData = startResponse['data'];
      // Simplify room name - remove special characters that might cause issues
      final rawRoomName = liveData['jitsi_room'] as String? ?? 'live_$liveId';
      final jitsiRoom = rawRoomName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      final jitsiToken = liveData['jitsi_token'] as String?;
      var jitsiServer = liveData['jitsi_server'] as String?;

      // Handle empty or null server URL
      if (jitsiServer == null || jitsiServer.trim().isEmpty) {
        // Use 8x8.vc instead of meet.jit.si - it works better with mobile SDKs
        jitsiServer = 'https://8x8.vc';
      } else if (!jitsiServer.startsWith('http://') && !jitsiServer.startsWith('https://')) {
        // Ensure server URL has protocol
        jitsiServer = 'https://$jitsiServer';
      }

      AppLogger.success('Live session started: $liveId', 'LiveSession');
      AppLogger.debug('Jitsi Server: $jitsiServer, Room: $jitsiRoom (original: $rawRoomName)', 'LiveSession');

      emit(LiveSessionStarted(liveId: liveId, title: title, jitsiRoom: jitsiRoom, jitsiToken: jitsiToken, jitsiServer: jitsiServer));
    } catch (e) {
      AppLogger.error('Error starting live session', 'LiveSession', e);
      emit(LiveSessionError('Failed to start live session: ${e.toString()}'));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const LiveSessionInitial());
  }
}
