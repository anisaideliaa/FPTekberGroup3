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
  final _potonganHargaController = TextEditingController();
  final _jumlahDisplayController = TextEditingController();
  final _jumlahGudangController = TextEditingController();
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
    _potonganHargaController.dispose();
    _jumlahDisplayController.dispose();
    _jumlahGudangController.dispose();
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
        'potongan': double.tryParse(_potonganHargaController.text) ?? 0,
        'display': int.tryParse(_jumlahDisplayController.text) ?? 0,
        'gudang': int.tryParse(_jumlahGudangController.text) ?? 0,
        'berat': double.tryParse(_beratProdukController.text) ?? 0,
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
      } on FirebaseException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan produk: ${e.message}')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan tidak dikenal')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nama Produk', _namaProdukController,
                  TextInputType.text, true),
              _buildTextField('Deskripsi Produk', _deskripsiProdukController,
                  TextInputType.multiline, false,
                  maxLines: 3),
              _buildDropdownJenisProduk(),
              _buildTextField('Harga Produk', _hargaProdukController,
                  TextInputType.number, true),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Placeholder: logika untuk melihat harga pasar
                },
                child: const Text('Lihat Harga Pasar'),
              ),
              _buildTextField('Potongan Harga Grosir', _potonganHargaController,
                  TextInputType.number, false),
              _buildTextField('Jumlah Produk Display', _jumlahDisplayController,
                  TextInputType.number, false),
              _buildTextField('Jumlah Produk Gudang', _jumlahGudangController,
                  TextInputType.number, false),
              _buildTextField('Berat Produk', _beratProdukController,
                  TextInputType.number, false),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanProduk,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType, bool required,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Jenis Produk'),
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
        ].map<DropdownMenuItem<String>>((String value) {
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
