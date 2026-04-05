import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/app_repository.dart';
import '../utils/app_logger.dart';
import 'live_session_state.dart';

class LiveSessionCubit extends Cubit<LiveSessionState> {
  final AppRepository _repository;

  LiveSessionCubit(this._repository) : super(const LiveSessionInitial());

  /// Create and start a live session
  Future<void> createAndStartLiveSession({
    required String title,
    String? thumbnail,
  }) async {
    try {
      emit(const LiveSessionCreating());
      AppLogger.info('Creating live session: $title', 'LiveSession');

      // Step 1: Create live session
      final createResponse = await _repository.createLiveSession(
        title: title,
        startTime: DateTime.now(),
        thumbnail: thumbnail,
      );

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
      final jitsiRoom = liveData['jitsi_room'] as String? ?? 'live_$liveId';
      final jitsiToken = liveData['jitsi_token'] as String?;
      final jitsiServer = liveData['jitsi_server'] as String? ?? 'meet.jit.si';

      AppLogger.success('Live session started: $liveId', 'LiveSession');
      
      emit(LiveSessionStarted(
        liveId: liveId,
        title: title,
        jitsiRoom: jitsiRoom,
        jitsiToken: jitsiToken,
        jitsiServer: jitsiServer,
      ));
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
