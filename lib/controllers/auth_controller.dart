// lib/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';
import '../services/shared_pref_service.dart'; // Asumsi SharedPrefService sudah benar

class AuthController with ChangeNotifier {
  // Dependency Injection untuk HiveService
  final HiveService _hiveService;
  
  // Data Statis untuk Registrasi
  static const String HARDCODE_NAME = 'Gwejh';
  static const String HARDCODE_NIM = '123220000';

  String? currentUsername;

  AuthController(this._hiveService); // Constructor menerima HiveService

  Future<bool> register(String username, String password) async {
    if (_hiveService.userExists(username)) return false;
    
    // Menggunakan nilai hardcode untuk Nama dan NIM saat user register
    final user = UserModel(
      username: username, 
      password: password,
      name: HARDCODE_NAME,
      nim: HARDCODE_NIM,
      photoBase64: null, // Initial photo is null
    );
    await _hiveService.registerUser(user);
    return true;
  }

  Future<bool> login(String username, String password) async {
    final user = _hiveService.getUser(username);
    if (user == null) return false;
    if (user.password == password) {
      currentUsername = username;
      await SharedPrefService.saveSession(username);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> tryAutoLogin() async {
    // SharedPrefService.getSession() harus mengembalikan Future<String?>
    final session = await SharedPrefService.getSession(); 
    if (session != null) {
      currentUsername = session;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    currentUsername = null;
    await SharedPrefService.clearSession();
    notifyListeners();
  }

  UserModel? getUserModel() {
    if (currentUsername == null) return null;
    return _hiveService.getUser(currentUsername!); // Menggunakan _hiveService
  }
}