import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/configs.dart';
import '../utils/http_client_wrapper.dart';

class HttpService {
  final http.Client _httpClient;

  // Private constructor
  HttpService._(this._httpClient);

  // Singleton instance
  static HttpService? _instance;

  // Factory constructor for singleton
  factory HttpService() {
    _instance ??= HttpService._(HttpClientManager.instance);
    return _instance!;
  }

  // Factory constructor for testing (allows custom client)
  factory HttpService.withClient(http.Client client) {
    return HttpService._(client);
  }

  // GET request
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = ApiConfig.buildUri(endpoint, queryParameters);
      final mergedHeaders = ApiConfig.mergeHeaders(headers);

      final response = await _httpClient.get(
        uri,
        headers: mergedHeaders,
      ).timeout(ApiConfig.timeoutDuration);

      return ApiConfig.handleResponse(response);
    } catch (e) {
      throw ApiConfig.handleError(e);
    }
  }

  // POST request
  Future<Map<String, dynamic>> post({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = ApiConfig.buildUri(endpoint, queryParameters);
      final mergedHeaders = ApiConfig.mergeHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;

      final response = await _httpClient.post(
        uri,
        headers: mergedHeaders,
        body: jsonBody,
      ).timeout(ApiConfig.timeoutDuration);

      return ApiConfig.handleResponse(response);
    } catch (e) {
      throw ApiConfig.handleError(e);
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = ApiConfig.buildUri(endpoint, queryParameters);
      final mergedHeaders = ApiConfig.mergeHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;

      final response = await _httpClient.put(
        uri,
        headers: mergedHeaders,
        body: jsonBody,
      ).timeout(ApiConfig.timeoutDuration);

      return ApiConfig.handleResponse(response);
    } catch (e) {
      throw ApiConfig.handleError(e);
    }
  }

  // PATCH request
  Future<Map<String, dynamic>> patch({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = ApiConfig.buildUri(endpoint, queryParameters);
      final mergedHeaders = ApiConfig.mergeHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;

      final response = await _httpClient.patch(
        uri,
        headers: mergedHeaders,
        body: jsonBody,
      ).timeout(ApiConfig.timeoutDuration);

      return ApiConfig.handleResponse(response);
    } catch (e) {
      throw ApiConfig.handleError(e);
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = ApiConfig.buildUri(endpoint, queryParameters);
      final mergedHeaders = ApiConfig.mergeHeaders(headers);

      final response = await _httpClient.delete(
        uri,
        headers: mergedHeaders,
      ).timeout(ApiConfig.timeoutDuration);

      return ApiConfig.handleResponse(response);
    } catch (e) {
      throw ApiConfig.handleError(e);
    }
  }

  // Multipart request (for file uploads)
  Future<Map<String, dynamic>> multipart({
    required String endpoint,
    required String method,
    Map<String, String>? fields,
    Map<String, String>? files,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = ApiConfig.buildUri(endpoint, queryParameters);
      final request = http.MultipartRequest(method, uri);

      // Add headers
      if (headers != null) {
        request.headers.addAll(ApiConfig.mergeHeaders(headers));
      } else {
        request.headers.addAll(ApiConfig.mergeHeaders(null));
      }

      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add files
      if (files != null) {
        for (final entry in files.entries) {
          request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
        }
      }

      final streamedResponse = await _httpClient.send(request).timeout(ApiConfig.timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      return ApiConfig.handleResponse(response);
    } catch (e) {
      throw ApiConfig.handleError(e);
    }
  }

  // Dispose method
  void dispose() {
    _httpClient.close();
    _instance = null;
  }

  // Reset singleton (useful for testing)
  static void reset() {
    _instance?.dispose();
    _instance = null;
  }
}