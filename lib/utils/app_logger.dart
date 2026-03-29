import 'package:flutter/foundation.dart';

class AppLogger {
  // Set to false in production to disable all logging
  static const bool _enableLogging = true;

  // Different log levels
  static const String _debugPrefix = '🔍';
  static const String _infoPrefix = 'ℹ️';
  static const String _warningPrefix = '⚠️';
  static const String _errorPrefix = '❌';
  static const String _successPrefix = '✅';

  /// Debug log - for debugging information
  static void debug(String message, [String? tag]) {
    if (_enableLogging) {
      final logMessage = tag != null ? '$_debugPrefix [$tag] $message' : '$_debugPrefix $message';
      if (kDebugMode) {
        print(logMessage);
      }
    }
  }

  /// Info log - for general information
  static void info(String message, [String? tag]) {
    if (_enableLogging) {
      final logMessage = tag != null ? '$_infoPrefix [$tag] $message' : '$_infoPrefix $message';
      if (kDebugMode) {
        print(logMessage);
      }
    }
  }

  /// Warning log - for warnings
  static void warning(String message, [String? tag]) {
    if (_enableLogging) {
      final logMessage = tag != null ? '$_warningPrefix [$tag] $message' : '$_warningPrefix $message';
      if (kDebugMode) {
        print(logMessage);
      }
    }
  }

  /// Error log - for errors
  static void error(String message, [String? tag, dynamic error]) {
    if (_enableLogging) {
      final logMessage = tag != null ? '$_errorPrefix [$tag] $message' : '$_errorPrefix $message';
      if (kDebugMode) {
        print(logMessage);
        if (error != null) {
          print('$_errorPrefix Error details: $error');
        }
      }
    }
  }

  /// Success log - for successful operations
  static void success(String message, [String? tag]) {
    if (_enableLogging) {
      final logMessage = tag != null ? '$_successPrefix [$tag] $message' : '$_successPrefix $message';
      if (kDebugMode) {
        print(logMessage);
      }
    }
  }

  /// Network log - specifically for API calls
  static void network(String message, [String? endpoint]) {
    if (_enableLogging) {
      final logMessage = endpoint != null ? '🌐 [$endpoint] $message' : '🌐 $message';
      if (kDebugMode) {
        print(logMessage);
      }
    }
  }

  /// Storage log - specifically for storage operations
  static void storage(String message) {
    if (_enableLogging) {
      if (kDebugMode) {
        print('💾 [Storage] $message');
      }
    }
  }

  /// Auth log - specifically for authentication operations
  static void auth(String message) {
    if (_enableLogging) {
      if (kDebugMode) {
        print('🔐 [Auth] $message');
      }
    }
  }

  /// Navigation log - specifically for navigation operations
  static void navigation(String message) {
    if (_enableLogging) {
      if (kDebugMode) {
        print('🧭 [Navigation] $message');
      }
    }
  }

  /// App lifecycle log - for app initialization, disposal, etc.
  static void lifecycle(String message) {
    if (_enableLogging) {
      if (kDebugMode) {
        print('🔄 [Lifecycle] $message');
      }
    }
  }

  /// Disable all logging (call this in production)
  static void disableLogging() {
    // In production, you can set _enableLogging to false
    // or call this method to override logging behavior
    if (kDebugMode) {
      print('🔇 AppLogger: Logging disabled');
    }
  }

  /// Log object/JSON data in a formatted way
  static void logObject(String title, dynamic object, [String? tag]) {
    if (_enableLogging && kDebugMode) {
      final logTitle = tag != null ? '$_debugPrefix [$tag] $title' : '$_debugPrefix $title';
      print(logTitle);
      print(object.toString());
    }
  }
}
