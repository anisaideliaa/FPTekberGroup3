import 'package:flutter/material.dart';

class InformasiBankPage extends StatefulWidget {
  const InformasiBankPage({super.key});

  @override
  State<InformasiBankPage> createState() => _InformasiBankPageState();
}

class _InformasiBankPageState extends State<InformasiBankPage> {
  final _namaBankController = TextEditingController(text: 'BCA');
  final _nomorRekeningController = TextEditingController(text: '1234567890');
  final _namaPemilikController = TextEditingController(text: 'Peter Crouch');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5E9),
      appBar: AppBar(
        title: const Text('Informasi Bank'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField('Nama Bank', _namaBankController, Icons.account_balance),
            _buildTextField('Nomor Rekening', _nomorRekeningController, Icons.numbers),
            _buildTextField('Nama Pemilik Rekening', _namaPemilikController, Icons.person),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Informasi bank berhasil disimpan')),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
