import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/cart_provider.dart';
import 'RiwayatPesanan.dart';

class PembayaranPage extends StatefulWidget {
  final CartProvider cartProvider;
  final double totalHarga;

  const PembayaranPage({
    Key? key,
    required this.cartProvider,
    required this.totalHarga,
  }) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  PlatformFile? _buktiPembayaran;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _buktiPembayaran = result.files.first;
      });
    }
  }

  void _onSudahBayar() {
    // TODO: Upload file to server or Firestore if needed
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/riwayat_pesanan',
      (route) => false,
    );
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
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
                      const Text(
                        'Transfer ke rekening berikut:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text('Bank: BNI', style: TextStyle(fontSize: 15)),
                      const Text('Nomor Rekening: 120xxxxxxxx54',
                          style: TextStyle(fontSize: 15, letterSpacing: 1.2)),
                      const Text('a.n. CV. Maju Jaya Hasil Tani',
                          style: TextStyle(fontSize: 15)),
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
                        '3. Klik tombol "Upload Bukti Pembayaran" dan pilih file bukti pembayaran Anda.\n'
                        '4. Setelah berhasil upload, klik tombol "Sudah Bayar".\n'
                        '5. Pesanan akan diproses setelah pembayaran terverifikasi.',
                        style: TextStyle(fontSize: 14),
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
                  onPressed: _buktiPembayaran == null ? null : _onSudahBayar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Sudah Bayar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
