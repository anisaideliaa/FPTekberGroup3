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

  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _hargaController;
  late TextEditingController _beratController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.data['nama']);
    _deskripsiController =
        TextEditingController(text: widget.data['deskripsi']);
    _hargaController =
        TextEditingController(text: widget.data['harga'].toString());
    _beratController =
        TextEditingController(text: widget.data['berat'].toString());
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _beratController.dispose();
    super.dispose();
  }

  Future<void> _updateProduk() async {
    if (_formKey.currentState!.validate()) {
      await ProductService().updateProduk(widget.id, {
        'nama': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'harga': double.tryParse(_hargaController.text) ?? 0,
        'berat': double.tryParse(_beratController.text) ?? 0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui')),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _hapusProduk() async {
    await ProductService().hapusProduk(widget.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk telah dihapus')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga'),
              ),
              TextFormField(
                controller: _beratController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Berat'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduk,
                child: const Text('Simpan Perubahan'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _hapusProduk,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Hapus Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
