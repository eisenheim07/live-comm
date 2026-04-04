abstract class StreamingState {}

class StreamingInitial extends StreamingState {}

class StreamingPermissionRequesting extends StreamingState {}

class StreamingPermissionGranted extends StreamingState {}

class StreamingPermissionDenied extends StreamingState {
  final String message;

  StreamingPermissionDenied(this.message);
}

class StreamingConnecting extends StreamingState {}

class StreamingConnected extends StreamingState {
  final int uid;
  final String channelName;

  StreamingConnected(this.uid, this.channelName);
}

class StreamingError extends StreamingState {
  final String message;

  StreamingError(this.message);
}

class StreamingDisconnected extends StreamingState {}
