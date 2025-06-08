import 'package:flutter/material.dart';

class RiwayatPesananPage extends StatelessWidget {
  const RiwayatPesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> riwayatPesanan = [
      {
        'produk': 'Ikan Nila Segar',
        'jumlah': 2,
        'harga': 45000,
        'status': 'Diproses',
        'tanggal': '6 Juni 2025'
      },
      {
        'produk': 'Pupuk Organik',
        'jumlah': 1,
        'harga': 30000,
        'status': 'Dikirim',
        'tanggal': '5 Juni 2025'
      },
      {
        'produk': 'Benih Padi',
        'jumlah': 3,
        'harga': 120000,
        'status': 'Selesai',
        'tanggal': '3 Juni 2025'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5E9),
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: riwayatPesanan.length,
        itemBuilder: (context, index) {
          final item = riwayatPesanan[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.shopping_basket, color: Color(0xFF5A6543)),
              title: Text(item['produk']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jumlah: ${item['jumlah']}'),
                  Text('Harga: Rp ${item['harga']}'),
                  Text('Tanggal: ${item['tanggal']}'),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(item['status']),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item['status'],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              onTap: () {
                // Tambahkan jika ingin detail pesanan
              },
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Diproses':
        return Colors.orange;
      case 'Dikirim':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
