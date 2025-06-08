import 'package:flutter/material.dart';

class InformasiAkunPage extends StatefulWidget {
  const InformasiAkunPage({super.key});

  @override
  State<InformasiAkunPage> createState() => _InformasiAkunPageState();
}

class _InformasiAkunPageState extends State<InformasiAkunPage> {
  final _namaController = TextEditingController(text: 'Peter Crouch');
  final _emailController = TextEditingController(text: 'peter@email.com');
  final _teleponController = TextEditingController(text: '+62 812 3456 7890');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5E9),
      appBar: AppBar(
        title: const Text('Informasi Akun'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField('Nama Lengkap', _namaController, Icons.person_outline),
            _buildTextField('Email', _emailController, Icons.email_outlined),
            _buildTextField('Nomor Telepon', _teleponController, Icons.phone_android),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A6543),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // simpan logika di sini
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Informasi berhasil diperbarui')),
                  );
                },
                child: const Text('Simpan'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}