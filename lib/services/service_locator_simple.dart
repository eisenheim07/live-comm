import 'http_service.dart';

/// Simple Service Locator without external dependencies
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Service instances
  HttpService? _httpService;

  // Get HttpService instance (lazy initialization)
  HttpService get httpService {
    _httpService ??= HttpService();
    return _httpService!;
  }

  // Initialize all services (call once at app startup)
  void initialize() {
    // Pre-initialize services if needed
    _httpService = HttpService();
  }

  // Dispose all services (call when app is disposed)
  void dispose() {
    _httpService?.dispose();
    _httpService = null;
  }

  // Reset all services (useful for testing)
  void reset() {
    dispose();
  }
}

// Global service locator instance
final serviceLocator = ServiceLocator();