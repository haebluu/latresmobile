import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// --- SERVICE IMPORTS ---
import 'services/hive_service.dart';
import 'services/shared_pref_service.dart';
// --- CONTROLLER IMPORTS ---
import 'controllers/auth_controller.dart';
import 'controllers/anime_controller.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/profile_controller.dart';
// --- VIEW IMPORTS ---
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'views/register_page.dart';


// 1. DEKLARASI TOP-LEVEL/GLOBAL:
// Deklarasikan instance service yang akan di-inject. Gunakan 'late' karena diinisialisasi di main.
late final HiveService hiveService; 
// Anda mungkin juga perlu menginisialisasi service lain di sini
// late final SharedPrefService sharedPrefService; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. INISIALISASI DI DALAM main:
  hiveService = HiveService();
  await hiveService.init();
  
  // Asumsi SharedPrefService.init() sudah memadai
  await SharedPrefService.init(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 3. INJEKSI: Variabel global/top-level 'hiveService' sudah dapat diakses.
        ChangeNotifierProvider(
          // Asumsi AuthController butuh SharedPrefService juga
          create: (_) => AuthController(hiveService), 
        ), 
        ChangeNotifierProvider(create: (_) => AnimeController()),
        ChangeNotifierProvider(create: (_) => FavoriteController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp(
        title: 'Latihan Responsi Mobile',
        theme: ThemeData(primarySwatch: Colors.indigo),
        // Gunakan named routes
        initialRoute: '/', 
        routes: {
          '/': (ctx) => const RootDecider(),
          '/login': (ctx) =>  LoginPage(),
          '/register': (ctx) =>  RegisterPage(),
          '/home': (ctx) =>  HomePage(),
        },
      ),
    );
  }
}

/// Decide to go to login or home based on session
class RootDecider extends StatelessWidget {
  const RootDecider({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan listen: false pada Provider karena kita hanya memicu Future
    final auth = Provider.of<AuthController>(context, listen: false); 
    
    // FutureBuilder akan menampilkan loading saat mencoba auto-login
    return FutureBuilder<bool>(
      future: auth.tryAutoLogin(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        // Setelah selesai, navigasi menggunakan named routes
        if (snap.data == true) {
          // Jika auto-login sukses, langsung ke home
          return  HomePage(); 
        } else {
          // Jika gagal/tidak ada sesi, ke login
          return  LoginPage();
        }
      },
    );
  }
}