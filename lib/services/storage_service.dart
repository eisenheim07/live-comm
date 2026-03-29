import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/app_logger.dart';

class StorageService {
  static const String _userKey = 'user_session';

  // Single SharedPreferences instance for entire app
  static SharedPreferences? _prefs;
  static UserModel? _currentUser;
  static bool _isInitialized = false;

  // Initialize SharedPreferences once at app startup
  static Future<void> init() async {
    if (_isInitialized) return; // Prevent multiple initializations

    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;

    // Load user from storage on init
    await _loadUserFromStorage();
  }

  // Ensure initialization before any operation
  static void _ensureInitialized() {
    if (!_isInitialized || _prefs == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
  }

  // Save entire user model as session
  static Future<void> saveUser(UserModel user) async {
    _ensureInitialized();
    AppLogger.logObject('Saving user', user.toJson(), 'Storage');
    _currentUser = user;
    await _prefs!.setString(_userKey, jsonEncode(user.toJson()));
    AppLogger.success('User saved successfully', 'Storage');
  }

  // Get current user model (from memory or storage)
  static Future<UserModel?> getUser() async {
    _ensureInitialized();
    if (_currentUser != null) {
      return _currentUser;
    }
    return await _loadUserFromStorage();
  }

  // Get current user synchronously (if already loaded)
  static UserModel? get user {
    _ensureInitialized();
    return _currentUser;
  }

  // Clear all user data and logout
  static Future<void> clearUser() async {
    _ensureInitialized();
    _currentUser = null;
    await _prefs!.remove(_userKey);
  }

  // Private method to load user from storage
  static Future<UserModel?> _loadUserFromStorage() async {
    _ensureInitialized();
    final String? userJson = _prefs!.getString(_userKey);
    AppLogger.debug('Loading user JSON: $userJson', 'Storage');
    
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        AppLogger.logObject('Decoded user data', userData, 'Storage');
        _currentUser = UserModel.fromJson(userData);
        AppLogger.logObject('Loaded user', _currentUser?.toJson(), 'Storage');
        AppLogger.debug('Loaded user token: ${_currentUser?.token}', 'Storage');
        return _currentUser;
      } catch (e) {
        // If there's an error parsing user data, clear it
        AppLogger.error('Error parsing user data', 'Storage', e);
        await clearUser();
        return null;
      }
    }
    AppLogger.info('No user data found', 'Storage');
    return null;
  }

  // Get initialization status
  static bool get isInitialized => _isInitialized;
}
