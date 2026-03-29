import 'http_service.dart';

// Service Locator instance
final GetIt serviceLocator = GetIt.instance;

/// Initialize all services
/// Call this once at app startup
void setupServiceLocator() {
  // Register HttpService as singleton
  serviceLocator.registerSingleton<HttpService>(HttpService());

  // Add other services here as needed
  // serviceLocator.registerSingleton<AuthService>(AuthService());
  // serviceLocator.registerSingleton<StorageService>(StorageService());
}

/// Dispose all services
/// Call this when app is disposed
void disposeServiceLocator() {
  serviceLocator.reset();
}
