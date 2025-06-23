import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TokoRegisterPage extends StatefulWidget {
  const TokoRegisterPage({super.key});

  @override
  State<TokoRegisterPage> createState() => _TokoRegisterPageState();
}

class _TokoRegisterPageState extends State<TokoRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Informasi Akun
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  // Alamat
  final TextEditingController _alamatController = TextEditingController();

  // Informasi Bank
  final TextEditingController _namaBankController = TextEditingController();
  final TextEditingController _noRekeningController = TextEditingController();
  final TextEditingController _pemilikRekeningController = TextEditingController();

  // Password
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> _registerToko() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await FirebaseFirestore.instance.collection('toko').add({
        'nama_lengkap': _namaLengkapController.text.trim(),
        'email': _emailController.text.trim(),
        'no_telp': _noTelpController.text.trim(),
        'alamat': _alamatController.text.trim(),
        'nama_bank': _namaBankController.text.trim(),
        'no_rekening': _noRekeningController.text.trim(),
        'pemilik_rekening': _pemilikRekeningController.text.trim(),
        'password': _passwordController.text.trim(),
        'created_at': DateTime.now(),
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun toko berhasil dibuat. Silakan login.')),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal mendaftar: $e';
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
      validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
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
      appBar: AppBar(
        title: const Text('Registrasi Toko'),
        backgroundColor: const Color(0xFF7D9250),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Informasi Akun',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _buildTextField(controller: _namaLengkapController, label: 'Nama Lengkap'),
              const SizedBox(height: 10),
              _buildTextField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 10),
              _buildTextField(controller: _noTelpController, label: 'No. Telepon', keyboardType: TextInputType.phone),

              const SizedBox(height: 20),
              const Text('Alamat Pengguna',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _buildTextField(controller: _alamatController, label: 'Alamat Lengkap'),

              const SizedBox(height: 20),
              const Text('Informasi Bank',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _buildTextField(controller: _namaBankController, label: 'Nama Bank'),
              const SizedBox(height: 10),
              _buildTextField(controller: _noRekeningController, label: 'No Rekening', keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(controller: _pemilikRekeningController, label: 'Nama Pemilik Rekening'),

              const SizedBox(height: 20),
              _buildTextField(controller: _passwordController, label: 'Password', obscure: true),

              const SizedBox(height: 20),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _registerToko,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C6E3B),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Daftar', style: TextStyle(color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
