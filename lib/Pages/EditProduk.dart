import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/product_service.dart';

class EditProdukPage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const EditProdukPage({super.key, required this.id, required this.data});

  @override
  State<EditProdukPage> createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jumlahDisplayController = TextEditingController();
  final _beratController = TextEditingController();
  String? _jenisProduk;

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.data['nama'] ?? '';
    _deskripsiController.text = widget.data['deskripsi'] ?? '';
    _hargaController.text = widget.data['harga'].toString();
    _jumlahDisplayController.text = widget.data['display'].toString();
    _beratController.text = widget.data['berat'].toString();
    _jenisProduk = widget.data['jenis'] ?? 'Pilih Jenis';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _jumlahDisplayController.dispose();
    _beratController.dispose();
    super.dispose();
  }

  Future<void> _updateProduk() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = {
        'nama': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'jenis': _jenisProduk,
        'harga': double.tryParse(_hargaController.text) ?? 0,
        'display': int.tryParse(_jumlahDisplayController.text) ?? 0,
        'berat': double.tryParse(_beratController.text) ?? 0,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await ProductService().updateProduk(widget.id, updatedProduct);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil diperbarui')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _hapusProduk() async {
    await ProductService().hapusProduk(widget.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk telah dihapus')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: AppBar(
        title: const Text('Edit Produk'),
        backgroundColor: const Color(0xFFF5F3E7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _formTitle('Informasi Produk'),
                  _buildTextField(
                      'Nama Produk', _namaController, TextInputType.text, true),
                  _buildTextField('Deskripsi Produk', _deskripsiController,
                      TextInputType.multiline, false,
                      maxLines: 3),
                  _buildDropdownJenisProduk(),
                  const SizedBox(height: 16),
                  _formTitle('Harga & Stok'),
                  _buildTextField('Harga Produk', _hargaController,
                      TextInputType.number, true),
                  _buildTextField('Jumlah Produk Display',
                      _jumlahDisplayController, TextInputType.number, false),
                  _buildTextField('Berat Produk (gram)', _beratController,
                      TextInputType.number, false),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _updateProduk,
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan Perubahan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _hapusProduk,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Hapus Produk',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      );

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType, bool required,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return '$label tidak boleh kosong';
          }
          if (keyboardType == TextInputType.number &&
              required &&
              double.tryParse(value!) == null) {
            return '$label harus berupa angka';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownJenisProduk() {
    final List<String> jenisList = [
      'Pilih Jenis',
      'Pendukung Pertanian',
      'Alat Pertanian',
      'Sayuran',
      'Buah-buahan',
      'Biji-bijian',
      'Umbi-umbian',
      'Pendukung Perikanan',
      'Alat Perikanan',
      'Ikan'
    ];

    // jika jenis tidak ada di list, tambahkan supaya tidak error
    if (!jenisList.contains(_jenisProduk)) {
      jenisList.insert(0, _jenisProduk ?? 'Pilih Jenis');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Jenis Produk',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        value: _jenisProduk,
        items: jenisList.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _jenisProduk = value;
          });
        },
        validator: (value) {
          if (value == null || value == 'Pilih Jenis') {
            return 'Jenis produk harus dipilih';
          }
          return null;
        },
      ),
    );
  }
}
