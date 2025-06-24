import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/product_service.dart';

class TambahProduk extends StatefulWidget {
  const TambahProduk({Key? key}) : super(key: key);

  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  final _formKey = GlobalKey<FormState>();
  final _namaProdukController = TextEditingController();
  final _deskripsiProdukController = TextEditingController();
  final _hargaProdukController = TextEditingController();
  final _jumlahProdukController = TextEditingController();
  final _beratProdukController = TextEditingController();
  String? _jenisProduk;

  @override
  void initState() {
    super.initState();
    _jenisProduk = 'Pilih Jenis';
  }

  @override
  void dispose() {
    _namaProdukController.dispose();
    _deskripsiProdukController.dispose();
    _hargaProdukController.dispose();
    _jumlahProdukController.dispose();
    _beratProdukController.dispose();
    super.dispose();
  }

  void _simpanProduk() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = {
        'nama': _namaProdukController.text,
        'deskripsi': _deskripsiProdukController.text,
        'jenis': _jenisProduk,
        'harga': double.parse(_hargaProdukController.text),
        'display': int.tryParse(_jumlahProdukController.text) ?? 0,
        'gudang': 0, // default
        'berat': double.tryParse(_beratProdukController.text) ?? 0,
        'potongan': 0, // default
        'createdAt': FieldValue.serverTimestamp(),
      };

      try {
        await ProductService().tambahProduk(newProduct);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil ditambahkan')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan produk: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: AppBar(
        title: const Text('Tambah Produk'),
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
                  _buildTextField('Nama Produk', _namaProdukController,
                      TextInputType.text, true),
                  _buildTextField(
                      'Deskripsi Produk',
                      _deskripsiProdukController,
                      TextInputType.multiline,
                      false,
                      maxLines: 3),
                  _buildDropdownJenisProduk(),
                  const SizedBox(height: 16),
                  _formTitle('Harga & Stok'),
                  _buildTextField('Harga Produk', _hargaProdukController,
                      TextInputType.number, true),
                  _buildTextField('Jumlah Produk Display',
                      _jumlahProdukController, TextInputType.number, false),
                  _buildTextField('Berat Produk (gram)', _beratProdukController,
                      TextInputType.number, false),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _simpanProduk,
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan Produk'),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Jenis Produk',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        value: _jenisProduk,
        items: <String>[
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
        ].map((value) {
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
