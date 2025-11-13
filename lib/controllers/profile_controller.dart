// lib/controllers/profile_controller.dart (Revisi untuk hardcode Nama & NIM)

import 'package:flutter/material.dart';
import '../services/shared_pref_service.dart';

class ProfileController with ChangeNotifier {
  // --- Data Hardcode ---
  String name = 'Gwejh'; // Hardcode Nama
  String nim = '123220000'; // Hardcode NIM
  // ---------------------

  String photoBase64 = ''; // optional stored profile photo

  ProfileController() {
    _loadProfilePhoto();
  }

  // Mengubah pemuatan foto menjadi Future/Async
  Future<void> _loadProfilePhoto() async {
    // Asumsi getProfilePhoto() ada di SharedPrefService dan mengembalikan String?
    final p = await SharedPrefService.getProfilePhoto(); 
    if (p != null && p.isNotEmpty) {
      photoBase64 = p;
      notifyListeners();
    }
  }

  Future<void> setPhoto(String base64) async {
    photoBase64 = base64;
    // Asumsi saveProfilePhoto() ada di SharedPrefService
    await SharedPrefService.saveProfilePhoto(base64);
    notifyListeners();
  }
}