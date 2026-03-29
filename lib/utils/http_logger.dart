import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'configs.dart';

class HttpLogger {
  static const String _tag = 'HTTP_INTERCEPTOR';

  // Enhanced request logging (Dio-style)
  static void logRequest({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    String? body,
  }) {
    if (!ApiConfig.enableHttpLogging) return;

    final buffer = StringBuffer();
    
    // Request header with method and URL
    buffer.writeln('*** Request ***');
    buffer.writeln('uri: $uri');
    buffer.writeln('method: $method');
    
    // Headers section
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('headers:');
      headers.forEach((key, value) {
        buffer.writeln(' $key: $value');
      });
    }
    
    // Body section
    if (body != null && body.isNotEmpty) {
      buffer.writeln('data:');
      try {
        // Try to format JSON body
        final jsonObject = jsonDecode(body);
        final prettyJson = JsonEncoder.withIndent(' ').convert(jsonObject);
        buffer.writeln(prettyJson);
      } catch (e) {
        // If not JSON, log as plain text
        buffer.writeln(body);
      }
    }
    
    buffer.writeln('*** End Request ***');
    
    developer.log(buffer.toString(), name: _tag);
  }

  // Enhanced response logging (Dio-style)
  static void logResponse({
    required http.Response response,
    required Duration duration,
  }) {
    if (!ApiConfig.enableHttpLogging) return;

    final buffer = StringBuffer();
    
    // Response header with status and timing
    buffer.writeln('*** Response ***');
    buffer.writeln('uri: ${response.request?.url}');
    buffer.writeln('statusCode: ${response.statusCode}');
    buffer.writeln('duration: ${duration.inMilliseconds}ms');
    
    // Headers section
    if (response.headers.isNotEmpty) {
      buffer.writeln('headers:');
      response.headers.forEach((key, value) {
        buffer.writeln(' $key: $value');
      });
    }
    
    // Response body section
    if (response.body.isNotEmpty) {
      buffer.writeln('data:');
      try {
        // Try to format JSON response
        final jsonObject = jsonDecode(response.body);
        final prettyJson = JsonEncoder.withIndent(' ').convert(jsonObject);
        buffer.writeln(prettyJson);
      } catch (e) {
        // If not JSON, log as plain text (truncate if too long)
        final body = response.body.length > 2000 
            ? '${response.body.substring(0, 2000)}...\n[Response body truncated]'
            : response.body;
        buffer.writeln(body);
      }
    }
    
    buffer.writeln('*** End Response ***');
    
    developer.log(buffer.toString(), name: _tag);
  }

  // Enhanced error logging (Dio-style)
  static void logError({
    required String method,
    required Uri uri,
    required dynamic error,
    Duration? duration,
  }) {
    if (!ApiConfig.enableHttpLogging) return;

    final buffer = StringBuffer();
    
    buffer.writeln('*** DioError ***');
    buffer.writeln('uri: $uri');
    buffer.writeln('method: $method');
    if (duration != null) {
      buffer.writeln('duration: ${duration.inMilliseconds}ms');
    }
    buffer.writeln('error: $error');
    
    // Add error type information
    if (error is Exception) {
      buffer.writeln('type: ${error.runtimeType}');
    }
    
    buffer.writeln('*** End DioError ***');
    
    developer.log(buffer.toString(), name: _tag);
  }

  // Compact logging for quick overview (similar to Dio's compact mode)
  static void logCompact({
    required String method,
    required Uri uri,
    required int statusCode,
    required Duration duration,
  }) {
    if (!ApiConfig.enableCompactLogging) return;

    final status = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    final path = uri.path.isEmpty ? '/' : uri.path;
    final message = '$status $method $path [$statusCode] (${duration.inMilliseconds}ms)';
    
    developer.log(message, name: _tag);
  }

  // Pretty print JSON (helper method)
  static String prettyPrintJson(String jsonString) {
    try {
      final jsonObject = jsonDecode(jsonString);
      return JsonEncoder.withIndent('  ').convert(jsonObject);
    } catch (e) {
      return jsonString;
    }
  }

  // Log curl command (useful for debugging)
  static void logCurl({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    String? body,
  }) {
    if (!ApiConfig.enableHttpLogging) return;

    final buffer = StringBuffer();
    buffer.write('curl -X $method');
    
    // Add headers
    if (headers != null) {
      headers.forEach((key, value) {
        buffer.write(' -H "$key: $value"');
      });
    }
    
    // Add body
    if (body != null && body.isNotEmpty) {
      buffer.write(' -d \'$body\'');
    }
    
    buffer.write(' "$uri"');
    
    developer.log('*** cURL ***\n${buffer.toString()}\n*** End cURL ***', name: _tag);
  }
}