import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/cart_provider.dart';

class PembayaranPage extends StatefulWidget {
  final CartProvider cartProvider;
  final double totalHarga;
  final String alamatPengiriman;

  const PembayaranPage({
    Key? key,
    required this.cartProvider,
    required this.totalHarga,
    required this.alamatPengiriman,
  }) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  PlatformFile? _buktiPembayaran;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _buktiPembayaran = result.files.first;
      });
    }
  }

  Future<void> _onSudahBayar() async {
    if (_buktiPembayaran == null || _buktiPembayaran!.bytes == null) return;

    setState(() => _isUploading = true);

    try {
      final base64String = base64Encode(_buktiPembayaran!.bytes as Uint8List);
      final firstItem = widget.cartProvider.items.first;

      await FirebaseFirestore.instance.collection('pesanan').add({
        'produk': firstItem.product.name,
        'jumlah': firstItem.quantity,
        'total': widget.totalHarga,
        'alamatPengiriman': widget.alamatPengiriman, // <-- Simpan alamat
        'imageBase64': firstItem.product.image,
        'buktiPembayaranBase64': base64String,
        'status': 'Menunggu Konfirmasi',
        'waktuPesan': Timestamp.now(),
      });

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/riwayat_pesanan',
          (route) => false,
        );
      }
    } catch (e) {
      print('Upload gagal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal upload bukti pembayaran')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Icon(Icons.account_balance_wallet,
                    size: 80, color: Colors.green[700]),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Transfer ke rekening berikut:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('Bank: BNI'),
                      const Text('Nomor Rekening: 120xxxxxxxx54'),
                      const Text('a.n. CV. Maju Jaya Hasil Tani'),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      const Text('Total Pembayaran:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        'Rp ${widget.totalHarga.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Instruksi Pembayaran:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text(
                        '1. Transfer sesuai nominal ke rekening di atas.\n'
                        '2. Simpan bukti pembayaran (foto/scan struk transfer).\n'
                        '3. Klik tombol "Upload Bukti Pembayaran".\n'
                        '4. Setelah upload berhasil, klik tombol "Sudah Bayar".\n'
                        '5. Pesanan akan diproses setelah verifikasi.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file),
                label: Text(_buktiPembayaran == null
                    ? 'Upload Bukti Pembayaran'
                    : 'Bukti Terupload: ${_buktiPembayaran!.name}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  minimumSize: const Size(200, 48),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  onPressed: (_buktiPembayaran == null || _isUploading)
                      ? null
                      : _onSudahBayar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sudah Bayar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
