import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_logger.dart';
import 'storage_service.dart';
import 'service_locator_simple.dart';

class AppInitializer {
  static bool _isInitialized = false;

  /// Initialize all app services at startup
  /// Call this once in main() before runApp()
  static Future<void> initialize() async {
    if (_isInitialized) return; // Prevent multiple initializations

    // Ensure Flutter binding is initialized
    WidgetsFlutterBinding.ensureInitialized();

    try {
      // Initialize core services in order
      await _initializeServices();

      // Set system UI configurations
      await _configureSystemUI();

      _isInitialized = true;
      AppLogger.success('App initialization completed successfully', 'Lifecycle');
    } catch (e) {
      AppLogger.error('App initialization failed', 'Lifecycle', e);
      rethrow;
    }
  }

  /// Initialize all services
  static Future<void> _initializeServices() async {
    AppLogger.lifecycle('Initializing app services...');

    // 1. Initialize SharedPreferences (Storage Service)
    AppLogger.lifecycle('Initializing StorageService...');
    await StorageService.init();
    AppLogger.success('StorageService initialized', 'Lifecycle');

    // 2. Initialize Service Locator (HTTP Service, etc.)
    AppLogger.lifecycle('Initializing ServiceLocator...');
    serviceLocator.initialize();
    AppLogger.success('ServiceLocator initialized', 'Lifecycle');

    // 3. Add other service initializations here
    // await NotificationService.init();
    // await CrashReportingService.init();
    // await AnalyticsService.init();

    AppLogger.success('All services initialized successfully', 'Lifecycle');
  }

  /// Configure system UI settings
  static Future<void> _configureSystemUI() async {
    AppLogger.lifecycle('Configuring system UI...');

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // Set preferred orientations (optional)
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    AppLogger.success('System UI configured', 'Lifecycle');
  }

  /// Dispose all services when app is closed
  static Future<void> dispose() async {
    if (!_isInitialized) return;

    AppLogger.lifecycle('Disposing app services...');

    try {
      // Dispose services in reverse order
      serviceLocator.dispose();
      // Add other service disposals here

      _isInitialized = false;
      AppLogger.success('App services disposed successfully', 'Lifecycle');
    } catch (e) {
      AppLogger.error('Error disposing app services', 'Lifecycle', e);
    }
  }

  /// Check if app is initialized
  static bool get isInitialized => _isInitialized;

  /// Get initialization status for debugging
  static Map<String, bool> getInitializationStatus() {
    return {
      'appInitialized': _isInitialized,
      'storageInitialized': StorageService.isInitialized,
      'serviceLocatorInitialized': serviceLocator.httpService != null,
    };
  }

  /// Reinitialize app (useful for testing or error recovery)
  static Future<void> reinitialize() async {
    await dispose();
    await initialize();
  }
}

/// Extension for easy debugging
extension AppInitializerDebug on AppInitializer {
  static void printStatus() {
    final status = AppInitializer.getInitializationStatus();
    AppLogger.debug('App Initialization Status:', 'Lifecycle');
    status.forEach((key, value) {
      final statusText = value ? 'initialized' : 'not initialized';
      AppLogger.debug('$key: $statusText', 'Lifecycle');
    });
  }
}
