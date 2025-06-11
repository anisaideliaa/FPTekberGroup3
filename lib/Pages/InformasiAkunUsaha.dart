import 'package:flutter/material.dart';

class InformasiAkunUsahaPage extends StatefulWidget {
  const InformasiAkunUsahaPage({super.key});

  @override
  State<InformasiAkunUsahaPage> createState() => _InformasiAkunPageState();
}

class _InformasiAkunPageState extends State<InformasiAkunUsahaPage> {
  // Controllers untuk setiap field input
  final TextEditingController _namaUsahaController =
      TextEditingController(text: 'CV. Maju Jaya Hasil Tani, Blok M');
  final TextEditingController _emailController =
      TextEditingController(text: 'petercrouch@gmail.com');
  final TextEditingController _namaPenggunaController =
      TextEditingController(text: 'Peter Crouch');
  final TextEditingController _kataSandiController = TextEditingController(
      text: '********'); // Representasi kata sandi tersembunyi

  bool _isEditing = false; // State untuk mengontrol mode edit

  @override
  void dispose() {
    // Pastikan untuk membuang controller saat widget di-dispose
    _namaUsahaController.dispose();
    _emailController.dispose();
    _namaPenggunaController.dispose();
    _kataSandiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7E8), // Warna latar belakang
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7E8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(
                context); // Kembali ke halaman sebelumnya (ScreenProfileUsaha)
          },
        ),
        title: const Text(
          'Informasi Akun', // Judul halaman
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true, // Judul di tengah
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Gambar Profil
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFF5D844A), width: 2),
              ),
              child: const Icon(
                Icons.account_circle, // Placeholder ikon orang
                size: 100,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Nama Usaha
            Text(
              _namaUsahaController.text, // Teks ini tidak bisa diedit
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 30),

            // Field Alamat Email
            _buildTextField(
              label: 'Alamat Email',
              controller: _emailController,
              isEnabled: _isEditing,
              isObscureText: false,
              suffixIcon: _isEditing ? Icons.edit : null,
            ),
            const SizedBox(height: 20),

            // Field Nama Pengguna
            _buildTextField(
              label: 'Nama Pengguna',
              controller: _namaPenggunaController,
              isEnabled: _isEditing,
              isObscureText: false,
              suffixIcon: _isEditing ? Icons.edit : null,
            ),
            const SizedBox(height: 20),

            // Field Kata Sandi
            _buildTextField(
              label: 'Kata Sandi',
              controller: _kataSandiController,
              isEnabled: _isEditing,
              isObscureText: true, // Sembunyikan teks
              suffixIcon: _isEditing ? Icons.edit : null,
            ),
            const SizedBox(height: 40),

            // Tombol Perbarui/Simpan Informasi Akun
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing; // Toggle mode edit
                });
                if (!_isEditing) {
                  // Jika beralih dari edit ke baca, berarti menyimpan perubahan
                  _saveAccountInfo();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D844A), // Warna tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Sudut melengkung
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                _isEditing
                    ? 'Simpan Informasi Akun'
                    : 'Perbarui Informasi Akun',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk membuat TextField kustom
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool isEnabled,
    bool isObscureText = false,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54, // Warna label
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          enabled: isEnabled,
          obscureText: isObscureText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            isDense: true, // Membuat TextField lebih ringkas secara vertikal
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.black54, size: 20)
                : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 30, minHeight: 0),
            enabledBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.black38), // Garis bawah saat enable
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFF5D844A), width: 2), // Garis bawah saat fokus
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  color:
                      Colors.black38), // Garis bawah saat disable (mode baca)
            ),
          ),
          readOnly:
              !isEnabled, // Membuat TextField hanya baca jika tidak dalam mode edit
        ),
      ],
    );
  }

  // Fungsi untuk "menyimpan" informasi akun
  void _saveAccountInfo() {
    // Di sini Anda akan menambahkan logika untuk menyimpan data ke database atau API
    // Contoh: print(_emailController.text);
    //         print(_namaPenggunaController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Informasi akun berhasil diperbarui!')),
    );
  }
}
