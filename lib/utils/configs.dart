import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiConfig {
  // API Configuration
  static const String baseUrl = 'https://nongranulated-alonso-nonschematically.ngrok-free.dev/api';
  static const Duration timeoutDuration = Duration(seconds: 30);

  // API End-Points
  static const String LOGIN = "auth/login";
  static const String REGISTER = "auth/register";
  static const String PROFILE = "auth/me";

  // Logging Configuration
  static const bool enableHttpLogging = true; // Set to false in production
  static const bool enableCompactLogging = true; // Quick overview logs

  // Default headers that will be used for all requests
  static Map<String, String> get defaultHeaders => {'Content-Type': 'application/json', 'Accept': 'application/json'};

  // Error messages configuration
  static const Map<int, String> statusCodeMessages = {
    400: 'Bad request. Please check your input.',
    401: 'Unauthorized. Please login again.',
    403: 'Access forbidden. You don\'t have permission.',
    404: 'Resource not found.',
    422: 'Validation failed. Please check your input.',
    429: 'Too many requests. Please try again later.',
    500: 'Server error. Please try again later.',
    502: 'Bad gateway. Please try again later.',
    503: 'Service unavailable. Please try again later.',
  };

  // Default error messages for different error types
  static const String defaultErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'No internet connection. Please check your network.';
  static const String clientErrorMessage = 'Network error. Please try again.';
  static const String formatErrorMessage = 'Invalid response format. Please try again.';
  static const String unexpectedErrorMessage = 'An unexpected error occurred. Please try again.';

  // Success response for non-JSON responses
  static const Map<String, String> successResponse = {'message': 'Success'};

  // Get error message based on status code
  static String getErrorMessage(int statusCode) {
    return statusCodeMessages[statusCode] ?? defaultErrorMessage;
  }

  // Build complete URL from endpoint
  static String buildUrl(String endpoint) {
    return endpoint.startsWith('http') ? endpoint : '$baseUrl/$endpoint';
  }

  // Check if status code indicates success
  static bool isSuccessStatusCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  // Build URI with query parameters
  static Uri buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final url = buildUrl(endpoint);
    final uri = Uri.parse(url);

    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters.map((key, value) => MapEntry(key, value.toString())));
    }

    return uri;
  }

  // Merge custom headers with default headers
  static Map<String, String> mergeHeaders(Map<String, String>? customHeaders) {
    final headers = Map<String, String>.from(defaultHeaders);
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  // Handle HTTP response
  static Map<String, dynamic> handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    try {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (isSuccessStatusCode(statusCode)) {
        // Check if status code is 200 but status is false
        final status = responseData['status'];
        if (statusCode == 200 && status == false) {
          // Backend returned error with 200 status code
          throw ApiException(
            message: responseData['message'] ?? 'Request failed',
            statusCode: statusCode,
            data: responseData,
            isBackendError: true,
          );
        }
        return responseData;
      } else {
        throw ApiException(
          message: responseData['message'] ?? getErrorMessage(statusCode),
          statusCode: statusCode,
          data: responseData,
          isBackendError: false,
        );
      }
    } on FormatException {
      if (isSuccessStatusCode(statusCode)) {
        return {
          ...successResponse,
          'data': response.body,
        };
      } else {
        throw ApiException(
          message: getErrorMessage(statusCode),
          statusCode: statusCode,
          isBackendError: false,
        );
      }
    }
  }

  // Handle errors and convert them to ApiException
  static ApiException handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    } else if (error is SocketException) {
      return const ApiException(
        message: networkErrorMessage,
        statusCode: 0,
        isBackendError: false,
      );
    } else if (error is http.ClientException) {
      return const ApiException(
        message: clientErrorMessage,
        statusCode: 0,
        isBackendError: false,
      );
    } else if (error is FormatException) {
      return const ApiException(
        message: formatErrorMessage,
        statusCode: 0,
        isBackendError: false,
      );
    } else {
      return const ApiException(
        message: unexpectedErrorMessage,
        statusCode: 0,
        isBackendError: false,
      );
    }
  }
}

// API Exception class
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;
  final bool isBackendError;

  const ApiException({
    required this.message, 
    required this.statusCode, 
    this.data,
    this.isBackendError = false,
  });

  @override
  String toString() => message;

  // Check if it's a validation error
  bool get isValidationError => statusCode == 422;

  // Check if it's an authentication error
  bool get isAuthError => statusCode == 401;

  // Check if it's a network error
  bool get isNetworkError => statusCode == 0;

  // Check if it's a server error
  bool get isServerError => statusCode >= 500;

  // Get formatted title for error display
  String get errorTitle {
    if (isBackendError) {
      return 'Error!';
    } else if (isNetworkError) {
      return 'Network Error!';
    } else {
      return 'Error! $statusCode';
    }
  }

  // Get appropriate error message for display
  String get displayMessage {
    if (isBackendError) {
      return message; // Show backend message directly
    } else {
      return 'Something went wrong, our team is working on it';
    }
  }
}
