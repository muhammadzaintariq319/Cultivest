import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cultivest_app/core/database/database_helper.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _loggedInUser = 'Current User';
  String _loggedInEmail = '';
  String _loggedInProfilePicture = '';
  String _loggedInDob = '';
  String _loggedInCountry = '';
  String _loggedInRole = 'farmer';

  bool get isLoggedIn => _isLoggedIn;
  String get loggedInUser => _loggedInUser;
  String get loggedInEmail => _loggedInEmail;
  String get loggedInProfilePicture => _loggedInProfilePicture;
  String get loggedInDob => _loggedInDob;
  String get loggedInCountry => _loggedInCountry;
  String get loggedInRole => _loggedInRole;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  AuthProvider() {
    loadSession();
  }

  Future<void> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (_isLoggedIn) {
        _loggedInUser = prefs.getString('loggedInUser') ?? 'Current User';
        _loggedInEmail = prefs.getString('loggedInEmail') ?? '';
        _loggedInRole = prefs.getString('loggedInRole') ?? 'farmer';
        _loggedInProfilePicture = prefs.getString('loggedInProfilePicture') ?? '';
        _loggedInDob = prefs.getString('loggedInDob') ?? '';
        _loggedInCountry = prefs.getString('loggedInCountry') ?? '';
        
        // Update static values in DatabaseHelper for compatibility
        DatabaseHelper.loggedInUser = _loggedInUser;
        DatabaseHelper.loggedInEmail = _loggedInEmail;
        DatabaseHelper.loggedInRole = _loggedInRole;
        DatabaseHelper.loggedInProfilePicture = _loggedInProfilePicture;
        DatabaseHelper.loggedInDob = _loggedInDob;
        DatabaseHelper.loggedInCountry = _loggedInCountry;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading login session: $e");
    }
  }

  Future<bool> login(String email, String password, String role) async {
    try {
      final user = await _dbHelper.getUser(email.trim(), password, role);
      if (user != null) {
        _isLoggedIn = true;
        _loggedInUser = user['name'] ?? 'User';
        _loggedInEmail = user['email'] ?? '';
        _loggedInProfilePicture = user['profile_picture'] ?? '';
        _loggedInDob = user['dob'] ?? '';
        _loggedInCountry = user['country'] ?? '';
        _loggedInRole = role;

        // Save in preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loggedInUser', _loggedInUser);
        await prefs.setString('loggedInEmail', _loggedInEmail);
        await prefs.setString('loggedInRole', _loggedInRole);
        await prefs.setString('loggedInProfilePicture', _loggedInProfilePicture);
        await prefs.setString('loggedInDob', _loggedInDob);
        await prefs.setString('loggedInCountry', _loggedInCountry);

        // Keep DatabaseHelper values in sync
        DatabaseHelper.loggedInUser = _loggedInUser;
        DatabaseHelper.loggedInEmail = _loggedInEmail;
        DatabaseHelper.loggedInRole = _loggedInRole;
        DatabaseHelper.loggedInProfilePicture = _loggedInProfilePicture;
        DatabaseHelper.loggedInDob = _loggedInDob;
        DatabaseHelper.loggedInCountry = _loggedInCountry;

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error during login: $e");
      return false;
    }
  }

  Future<bool> checkEmailExists(String email, String role) async {
    try {
      return await _dbHelper.emailExistsForRole(email, role);
    } catch (e) {
      debugPrint("Error checking if email exists: $e");
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> userDetails, String role) async {
    try {
      int id = await _dbHelper.insertUser({
        'name': userDetails['name'],
        'email': userDetails['email'],
        'phone': userDetails['phone'],
        'password': userDetails['password'],
        'role': role,
        'profile_picture': userDetails['profile_picture'] ?? '',
        'dob': userDetails['dob'] ?? '',
        'country': userDetails['country'] ?? '',
      });
      return id > 0;
    } catch (e) {
      debugPrint("Error registering user: $e");
      return false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updatedDetails) async {
    try {
      int rows = await _dbHelper.updateUser(updatedDetails, _loggedInEmail, _loggedInRole);
      if (rows > 0) {
        _loggedInUser = updatedDetails['name'] ?? _loggedInUser;
        _loggedInProfilePicture = updatedDetails['profile_picture'] ?? _loggedInProfilePicture;
        _loggedInDob = updatedDetails['dob'] ?? _loggedInDob;
        _loggedInCountry = updatedDetails['country'] ?? _loggedInCountry;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUser', _loggedInUser);
        await prefs.setString('loggedInProfilePicture', _loggedInProfilePicture);
        await prefs.setString('loggedInDob', _loggedInDob);
        await prefs.setString('loggedInCountry', _loggedInCountry);

        DatabaseHelper.loggedInUser = _loggedInUser;
        DatabaseHelper.loggedInProfilePicture = _loggedInProfilePicture;
        DatabaseHelper.loggedInDob = _loggedInDob;
        DatabaseHelper.loggedInCountry = _loggedInCountry;

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoggedIn = false;
      _loggedInUser = 'Current User';
      _loggedInEmail = '';
      _loggedInProfilePicture = '';
      _loggedInDob = '';
      _loggedInCountry = '';
      _loggedInRole = 'farmer';

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await DatabaseHelper.clearLoginSession();
      notifyListeners();
    } catch (e) {
      debugPrint("Error during logout: $e");
    }
  }
}
