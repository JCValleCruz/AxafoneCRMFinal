import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/user.dart';

class SessionService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  static User? _currentUser;

  static User? get currentUser => _currentUser;

  static bool get isLoggedIn => _currentUser != null;

  // Initialize session from stored data
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        _currentUser = User.fromJson(userData);
      } catch (e) {
        // If there's an error parsing stored data, clear it
        await logout();
      }
    }
  }

  // Save user session
  static Future<void> saveSession(User user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Clear session
  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  // Check if user has specific role
  static bool hasRole(String role) {
    return _currentUser?.role == role;
  }

  // Check if user can access admin features
  static bool canAccessAdmin() {
    return _currentUser?.role == 'ADMINISTRADOR';
  }

  // Check if user can manage team
  static bool canManageTeam() {
    return _currentUser?.role == 'JEFE_EQUIPO' ||
           _currentUser?.role == 'ADMINISTRADOR';
  }

  // Check if user can view reports
  static bool canViewReports() {
    return _currentUser?.role == 'JEFE_EQUIPO' ||
           _currentUser?.role == 'ADMINISTRADOR';
  }

  // Get user's team ID (for team leaders and admins)
  static int? getTeamId() {
    if (_currentUser?.role == 'JEFE_EQUIPO') {
      return _currentUser?.id;
    }
    return null;
  }

  // Get boss ID for comercials
  static int? getBossId() {
    return _currentUser?.bossId;
  }
}