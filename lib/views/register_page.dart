import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _form = GlobalKey<FormState>();
  String username = '', password = '', name = '', nim = '';
  bool loading = false;
  String? message;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.purple.shade200,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _form,
            child: Column(
              children: [
                const Text(
                  'MyAnimeArchive',
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
                  validator: (v) => (v == null || v.isEmpty) ? 'Masukkan username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onSaved: (v) => password = v ?? '',
                  validator: (v) => (v == null || v.isEmpty) ? 'Masukkan password' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nama (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => name = v ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'NIM (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => nim = v ?? '',
                ),
                const SizedBox(height: 24),
                if (message != null)
                  Text(message!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7B42F6), // Ungu tua
                        Color(0xFFB01EFF), // Ungu muda ke pink
                      ],
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
                              setState(() => loading = true);
                              final ok = await auth.register(username, password,);
                              setState(() => loading = false);
                              if (ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Register berhasil! Silakan login.')),
                                );
                                Navigator.pushReplacementNamed(context, '/login');
                              } else {
                                setState(() => message = 'Username sudah digunakan');
                              }
                            },
                      child: Center(
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Register',
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


                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Sudah punya akun? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
