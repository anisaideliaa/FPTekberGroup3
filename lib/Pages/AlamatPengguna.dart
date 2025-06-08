import 'package:flutter/material.dart';

class AlamatPenggunaPage extends StatefulWidget {
  const AlamatPenggunaPage({super.key});

  @override
  State<AlamatPenggunaPage> createState() => _AlamatPenggunaPageState();
}

class _AlamatPenggunaPageState extends State<AlamatPenggunaPage> {
  final _labelAlamatController = TextEditingController(text: 'Alamat Rumah');
  final _alamatLengkapController = TextEditingController(
      text: 'Jl. Raya Bogor No. 012, Kota Bogor, Jawa Barat');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5E9),
      appBar: AppBar(
        title: const Text('Alamat Pengguna'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField('Label Alamat', _labelAlamatController, Icons.label_outline),
            _buildTextField('Alamat Lengkap', _alamatLengkapController, Icons.location_on_outlined, maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alamat berhasil diperbarui')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A6543),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
