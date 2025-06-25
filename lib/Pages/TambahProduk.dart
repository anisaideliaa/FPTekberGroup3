import 'dart:io';
import 'dart:typed_data'; // Untuk Uint8List
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // Import ini untuk deteksi web

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

  // Ubah tipe variabel ini untuk mendukung File atau bytes
  File? _selectedImageFile; // Digunakan untuk pratinjau di non-web
  Uint8List?
      _selectedImageBytes; // Digunakan untuk pratinjau dan unggah di web/lainnya

  String? _uploadedImageUrl;
  bool _isUploading = false;

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

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        if (kIsWeb) {
          // Jika di web, baca sebagai bytes langsung
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImageFile = null; // Pastikan ini null
            _uploadedImageUrl = null;
          });
        } else {
          // Jika di mobile (Android/iOS), gunakan File
          setState(() {
            _selectedImageFile = File(image.path);
            _selectedImageBytes = null; // Pastikan ini null
            _uploadedImageUrl = null;
          });
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada gambar yang dipilih.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memilih gambar: $e')),
        );
      }
      print('Error picking image: $e');
    }
  }

  Future<String?> _uploadImageToFirebase() async {
    setState(() {
      _isUploading = true;
    });

    Uint8List? finalImageBytes;
    String? originalFileName;

    if (_selectedImageBytes != null) {
      // Jika gambar dipilih sebagai bytes (misal dari web)
      finalImageBytes = _selectedImageBytes;
      originalFileName = 'web_upload_image.jpg'; // Nama default untuk web
    } else if (_selectedImageFile != null) {
      // Jika gambar dipilih sebagai File (misal dari mobile)
      try {
        finalImageBytes = await _selectedImageFile!.readAsBytes();
        originalFileName = p.basename(_selectedImageFile!.path);
      } catch (e) {
        print('Error reading file bytes: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal membaca data gambar.')),
          );
        }
        setState(() {
          _isUploading = false;
        });
        return null;
      }
    } else {
      // Ini seharusnya tidak terjadi jika validasi sudah dilakukan
      setState(() {
        _isUploading = false;
      });
      return null;
    }

    if (finalImageBytes == null) {
      setState(() {
        _isUploading = false;
      });
      return null;
    }

    try {
      // Kompresi Gambar sebagai bytes
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
        finalImageBytes,
        quality: 80, // Kualitas kompresi: 80% (bisa disesuaikan)
        format: CompressFormat.jpeg, // Output format: JPEG
      );

      if (compressedBytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengkompresi gambar.')),
          );
        }
        setState(() {
          _isUploading = false;
        });
        return null;
      }

      // Unggah Bytes yang Sudah Dikompresi
      String fileExtension = p.extension(originalFileName ?? '').isNotEmpty
          ? p.extension(originalFileName!)
          : '.jpg'; // Fallback jika tidak ada ekstensi
      String fileName =
          'products/${DateTime.now().millisecondsSinceEpoch}_product$fileExtension';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = storageRef.putData(compressedBytes);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = downloadUrl;
        _isUploading = false;
      });

      return downloadUrl;
    } on FirebaseException catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar: ${e.message}')),
        );
      }
      print('Error uploading image: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan tak terduga: $e')),
        );
      }
      print('Unexpected error in upload process: $e');
      return null;
    }
  }

  void _simpanProduk() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImageFile == null && _selectedImageBytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Silakan pilih gambar produk terlebih dahulu')),
          );
        }
        return;
      }

      // Unggah gambar terlebih dahulu
      String? imageUrl =
          await _uploadImageToFirebase(); // Panggil tanpa parameter

      if (imageUrl == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Gagal menyimpan produk karena unggah gambar gagal.')),
          );
        }
        return;
      }

      final newProduct = {
        'nama': _namaProdukController.text,
        'deskripsi': _deskripsiProdukController.text,
        'jenis': _jenisProduk,
        'harga': double.parse(_hargaProdukController.text),
        'display': int.tryParse(_jumlahProdukController.text) ?? 0,
        'gudang': 0, // default
        'berat': double.tryParse(_beratProdukController.text) ?? 0,
        'potongan': 0, // default
        'imageUrl': imageUrl, // URL gambar yang sudah diunggah
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
                  _formTitle('Foto Produk'),
                  _buildImagePickerSection(),
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
                      onPressed: _isUploading ? null : _simpanProduk,
                      icon: _isUploading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.save),
                      label: Text(
                          _isUploading ? 'Mengunggah...' : 'Simpan Produk'),
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

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logika untuk menampilkan pratinjau gambar
        (_selectedImageFile != null || _selectedImageBytes != null)
            ? Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _selectedImageFile != null
                      ? Image.file(
                          _selectedImageFile!,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          // Gunakan Image.memory untuk bytes
                          _selectedImageBytes!,
                          fit: BoxFit.cover,
                        ),
                ),
              )
            : Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey[400],
                ),
              ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.upload_file),
          label: const Text('Pilih Foto Produk'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        if (_isUploading)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 8),
                Text('Mengunggah gambar...'),
              ],
            ),
          )
        else if (_uploadedImageUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Gambar berhasil diunggah!',
              style: TextStyle(color: Colors.green[700]),
            ),
          ),
      ],
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
