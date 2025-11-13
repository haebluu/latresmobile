// lib/services/hive_service.dart

import 'package:hive/hive.dart';
import '../models/user_model.dart';
import 'package:path_provider/path_provider.dart'; // Diperlukan untuk inisialisasi Hive

class HiveService {
  late Box<UserModel> _userBox;
  static const String boxName = 'users';

  // --- Wajib: Inisialisasi Service ---
  Future<void> init() async {
    // Pastikan Hive sudah diinisialisasi (misalnya di main.dart)
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Pastikan adapter terdaftar
    if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserModelAdapter());
    }
    
    _userBox = await Hive.openBox<UserModel>(boxName);
  }
  // ------------------------------------

  Future<void> registerUser(UserModel user) async {
    // Menyimpan UserModel langsung, key-nya adalah username
    await _userBox.put(user.username, user);
  }

  UserModel? getUser(String username) {
    // Mengambil UserModel langsung
    return _userBox.get(username);
  }

  bool userExists(String username) {
    return _userBox.containsKey(username);
  }
}