import 'package:flutter/material.dart';

class GantiPasswordPage extends StatelessWidget {
  const GantiPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5E9),
      appBar: AppBar(
        title: const Text('Ganti Kata Sandi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildPasswordField('Password Lama'),
            const SizedBox(height: 16),
            _buildPasswordField('Password Baru'),
            const SizedBox(height: 16),
            _buildPasswordField('Konfirmasi Password Baru'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Logika ganti password
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A6543),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan Password Baru'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
