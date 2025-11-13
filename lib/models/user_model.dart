
import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Wajib: Jalankan build runner

@HiveType(typeId: 0) // Wajib: Beri ID unik
class UserModel extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;
  
  // Hardcode values akan disimpan di sini saat registrasi (jika tidak diinput user)
  @HiveField(2)
  final String? name; 
  
  @HiveField(3)
  final String? nim;
  
  @HiveField(4)
  final String? photoBase64;

  UserModel({
    required this.username,
    required this.password,
    this.name,
    this.nim,
    this.photoBase64,
  });

  // Catatan: toMap() dan fromMap() tidak lagi diperlukan jika menggunakan HiveObject
  // dan mendaftarkan adapter.
}