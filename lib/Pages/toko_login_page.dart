import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TokoLoginPage extends StatefulWidget {
  const TokoLoginPage({super.key});

  @override
  State<TokoLoginPage> createState() => _TokoLoginPageState();
}

class _TokoLoginPageState extends State<TokoLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> _loginToko() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('toko')
          .where('email', isEqualTo: _emailController.text.trim())
          .where('password', isEqualTo: _passwordController.text.trim())
          .get();

      if (snapshot.docs.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/toko_homepage');
      } else {
        setState(() {
          errorMessage = 'Email atau password salah';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFEFEFEF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: Image.asset(
                'assets/LogoPasarTani.png', // Pastikan logo ini tersedia
                width: 180,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Kata Sandi',
                        obscure: true,
                      ),
                      const SizedBox(height: 10),
                      if (errorMessage != null)
                        Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 20),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _loginToko,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5C6E3B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/toko_register');
                        },
                        child: const Text(
                          'Belum punya akun toko? Daftar',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: const Color(0xFF7D9250),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // kembali ke login utama
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Kembali ke ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Login Pengguna',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
