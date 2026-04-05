import 'package:equatable/equatable.dart';

abstract class LiveSessionState extends Equatable {
  const LiveSessionState();

  @override
  List<Object?> get props => [];
}

class LiveSessionInitial extends LiveSessionState {
  const LiveSessionInitial();
}

class LiveSessionCreating extends LiveSessionState {
  const LiveSessionCreating();
}

class LiveSessionCreated extends LiveSessionState {
  final String liveId;
  final String title;

  const LiveSessionCreated({
    required this.liveId,
    required this.title,
  });

  @override
  List<Object?> get props => [liveId, title];
}

class LiveSessionStarting extends LiveSessionState {
  final String liveId;

  const LiveSessionStarting(this.liveId);

  @override
  List<Object?> get props => [liveId];
}

class LiveSessionStarted extends LiveSessionState {
  final String liveId;
  final String title;
  final String jitsiRoom;
  final String? jitsiToken;
  final String jitsiServer;

  const LiveSessionStarted({
    required this.liveId,
    required this.title,
    required this.jitsiRoom,
    this.jitsiToken,
    required this.jitsiServer,
  });

  @override
  List<Object?> get props => [liveId, title, jitsiRoom, jitsiToken, jitsiServer];
}

class LiveSessionError extends LiveSessionState {
  final String message;

  const LiveSessionError(this.message);

  @override
  List<Object?> get props => [message];
}
