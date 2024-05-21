import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final ApiService _apiService;

  User? get user => _user;

  AuthProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService() {
    tryAutoLogin();
  }

  Future<bool> login(String username, String password) async {
    final user = await _apiService.login(username, password);
    if (user != null) {
      _user = user;
      await saveUserToLocalStorage(user);
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() async {
    _user = null;
    await removeUserFromLocalStorage();
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final userJson = prefs.getString('user');
      if (userJson != null) {
        _user = User.fromJson(jsonDecode(userJson));
        notifyListeners();
      }
    }
  }

  Future<void> saveUserToLocalStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<void> removeUserFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
