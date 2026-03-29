import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'http_logger.dart';
import 'configs.dart';

class HttpClientWrapper extends http.BaseClient {
  final http.Client _inner;
  
  HttpClientWrapper(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Log request
      await _logRequest(request);
      
      // Send request
      final response = await _inner.send(request);
      
      stopwatch.stop();
      
      // Convert StreamedResponse to Response for logging
      final responseBytes = await response.stream.toBytes();
      final httpResponse = http.Response.bytes(
        responseBytes,
        response.statusCode,
        request: request,
        headers: response.headers,
        reasonPhrase: response.reasonPhrase,
      );
      
      // Log response
      HttpLogger.logResponse(
        response: httpResponse,
        duration: stopwatch.elapsed,
      );
      
      // Log compact version
      HttpLogger.logCompact(
        method: request.method,
        uri: request.url,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
      );
      
      // Return new StreamedResponse with the same data
      return http.StreamedResponse(
        Stream.fromIterable([responseBytes]),
        response.statusCode,
        contentLength: responseBytes.length,
        request: request,
        headers: response.headers,
        reasonPhrase: response.reasonPhrase,
      );
      
    } catch (e) {
      stopwatch.stop();
      
      // Log error
      HttpLogger.logError(
        method: request.method,
        uri: request.url,
        error: e,
        duration: stopwatch.elapsed,
      );
      
      rethrow;
    }
  }

  Future<void> _logRequest(http.BaseRequest request) async {
    String? body;
    
    // Extract body for logging
    if (request is http.Request) {
      body = request.body;
    } else if (request is http.MultipartRequest) {
      // For multipart requests, log fields only (not files)
      final fields = request.fields;
      if (fields.isNotEmpty) {
        body = 'Multipart fields: ${jsonEncode(fields)}';
      }
    }
    
    // Log detailed request
    HttpLogger.logRequest(
      method: request.method,
      uri: request.url,
      headers: request.headers,
      body: body,
    );
    
    // Log cURL command for easy debugging
    HttpLogger.logCurl(
      method: request.method,
      uri: request.url,
      headers: request.headers,
      body: body,
    );
  }

  @override
  void close() {
    _inner.close();
  }
}

class HttpClientManager {
  static HttpClientWrapper? _instance;
  
  static HttpClientWrapper get instance {
    _instance ??= HttpClientWrapper(http.Client());
    return _instance!;
  }
  
  static void dispose() {
    _instance?.close();
    _instance = null;
  }
  
  // Create a new instance (useful for testing)
  static HttpClientWrapper create() {
    return HttpClientWrapper(http.Client());
  }
}