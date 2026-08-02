import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;

  Future<String?> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await _authService.login(email: email, password: password);

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await _authService.register(email: email, password: password);

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    print("Logout button pressed");

    await _authService.logout();

    print("Firebase signOut completed");
  }
}
