import 'package:flutter/material.dart';

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
              Padding( // Tambahkan Padding di setiap TextFormField
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                  controller: _namaProdukController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
                  controller: _deskripsiProdukController,
                  maxLines: 3,
                ),
              ),
              Padding(
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Harga Produk'),
                  controller: _hargaProdukController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga produk tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Harga produk harus berupa angka';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Logika untuk melihat harga pasar
                  },
                  child: const Text('Lihat Harga Pasar'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Potongan Harga Grosir'),
                  controller: _potonganHargaController,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Jumlah Produk Display'),
                  controller: _jumlahDisplayController,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Jumlah Produk Gudang'),
                  controller: _jumlahGudangController,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Berat Produk'),
                  controller: _beratProdukController,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newProduct = {
                        'nama': _namaProdukController.text,
                        'deskripsi': _deskripsiProdukController.text,
                        'jenis': _jenisProduk,
                        'harga': double.parse(_hargaProdukController.text),
                        'potongan': _potonganHargaController.text,
                        'display': _jumlahDisplayController.text,
                        'gudang': _jumlahGudangController.text,
                        'berat': _beratProdukController.text,
                      };

                      Navigator.pop(context, newProduct);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}