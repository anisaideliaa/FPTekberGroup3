import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/cart_provider.dart';
import 'RiwayatPesanan.dart'; // pastikan path ini sesuai

class PembayaranPage extends StatelessWidget {
  final CartProvider cartProvider;
  final double totalHarga;

  const PembayaranPage({
    Key? key,
    required this.cartProvider,
    required this.totalHarga,
  }) : super(key: key);

  void _kirimPesananKeFirestore(BuildContext context) async {
    final now = DateTime.now();

    for (var item in cartProvider.items) {
      await FirebaseFirestore.instance.collection('pesanan').add({
        'produk': item.product.name,
        'jumlah': item.quantity,
        'total': totalHarga.toInt(),
        'status': 'Menunggu Konfirmasi', // status untuk RiwayatPesananPage
        'nama_pembeli': 'Nama Pembeli Demo', // bisa ambil dari auth jika ada
        'timestamp': now,
      });
    }

    cartProvider.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pembayaran berhasil dikonfirmasi!')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RiwayatPesananPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nomor Rekening: 120xxxxxxx54 (BNI)'),
            Text('Total Pembayaran: Rp ${totalHarga.toInt()}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _kirimPesananKeFirestore(context),
              child: const Text('Sudah Bayar'),
            ),
          ],
        ),
      ),
    );
  }
}
