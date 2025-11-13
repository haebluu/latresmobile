// lib/views/profile_page.dart (Revisi: Nama/NIM dari ProfileController, Username dari AuthController)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan dari AuthController (untuk sesi user)
    final auth = Provider.of<AuthController>(context);
    // Dengarkan perubahan dari ProfileController (untuk foto, nama, nim hardcode)
    final profile = Provider.of<ProfileController>(context);

    // Dapatkan model user yang sedang login untuk Username
    // Catatan: Asumsi auth.getUserModel() mengembalikan UserModel? atau sejenisnya
    final user = auth.getUserModel(); 

    // Fungsi untuk menampilkan avatar/foto
    Widget avatar() {
      if (profile.photoBase64.isNotEmpty) {
        try {
          final bytes = base64Decode(profile.photoBase64);
          return CircleAvatar(radius: 50, backgroundImage: MemoryImage(bytes));
        } catch (_) {
          // Jika decode gagal
          return const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50));
        }
      }
      // Avatar default jika tidak ada foto
      return const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50));
    }

    return Scaffold(
      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              avatar(),
              const SizedBox(height: 16),
              
              // Tampilkan Nama dari ProfileController (hardcode)
              Text(profile.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 4),
              
              // Tampilkan NIM dari ProfileController (hardcode)
              Text(profile.nim,
                  style: const TextStyle(fontSize: 16, color: Colors.black)),
              const SizedBox(height: 4),
              
              // Tampilkan Username dari AuthController (dinamis/sesi)
              Text('Logged in as: ${user?.username ?? '-'}',
                  style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 32),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () async {
                  // Asumsi logout di AuthController
                  await auth.logout();
                  Navigator.pushReplacementNamed(context, '/login'); // Logout perlu context untuk navigasi Navigator
                  // Asumsi navigasi diurus di dalam auth.logout() atau gunakan Navigator standar:
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage())); 
                },
                child: const Text('Logout',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}