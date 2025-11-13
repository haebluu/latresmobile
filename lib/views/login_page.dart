import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  String username = '', password = '';
  bool loading = false;
  String? message;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.purple.shade200,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'MyAnime',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => username = v?.trim() ?? '',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Masukkan username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onSaved: (v) => password = v ?? '',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Masukkan password' : null,
                ),
                const SizedBox(height: 24),
                if (message != null)
                  Text(message!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),

                // ✅ Tombol gradient + logic login dikembalikan
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B42F6), Color(0xFFB01EFF)],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: loading
                          ? null
                          : () async {
                              if (!_form.currentState!.validate()) return;
                              _form.currentState!.save();

                              setState(() {
                                loading = true;
                                message = null;
                              });

                              final ok = await auth.login(username, password);
                              setState(() => loading = false);

                              if (ok) {
                                Navigator.pushReplacementNamed(context, '/home');
                              } else {
                                setState(() =>
                                    message = 'Username atau password salah');
                              }
                            },
                      child: Center(
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/register'),
                  child: const Text('Belum punya akun? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
