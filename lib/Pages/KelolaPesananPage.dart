import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Jika masih menggunakan Firestore untuk data pesanan toko

// Import halaman-halaman yang akan dituju oleh Bottom Nav Bar di halaman ini
import 'package:pasar_tani_nelayan/Pages/HomeToko.dart'; // Untuk navigasi kembali ke Produk Toko
import 'package:pasar_tani_nelayan/Pages/ProfilUsaha.dart'; // Untuk navigasi ke Profil Usaha Toko

class KelolaPesananPage extends StatefulWidget {
  const KelolaPesananPage({super.key});

  @override
  State<KelolaPesananPage> createState() => _KelolaPesananPageState();
}

class _KelolaPesananPageState extends State<KelolaPesananPage> {
  int _selectedIndex = 1; // 'Kelola Pesanan' adalah index 1 di navbar ini

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Produk
        Navigator.pushReplacementNamed(context, '/toko_homepage');
        break;
      case 1: // Kelola Pesanan
        // Sudah di halaman ini, tidak perlu navigasi
        break;
      case 2: // Profil Usaha
        Navigator.pushReplacementNamed(context, '/profil_usaha');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Anda bisa mengganti ini dengan StreamBuilder dari Firestore
    // seperti yang ada di _buildKelolaPesananSection di HomeToko sebelumnya
    final List<Map<String, dynamic>> dummyPesananToko = [
      {
        'id_pesanan': 'ORD001',
        'nama_pembeli': 'Adi Santoso',
        'produk': 'Sayur Kangkung',
        'jumlah': '5 ikat',
        'total': 25000,
        'status': 'Menunggu Konfirmasi',
      },
      {
        'id_pesanan': 'ORD002',
        'nama_pembeli': 'Budi Cahyono',
        'produk': 'Buah Naga',
        'jumlah': '2 KG',
        'total': 60000,
        'status': 'Sedang Dikemas',
      },
      {
        'id_pesanan': 'ORD003',
        'nama_pembeli': 'Citra Dewi',
        'produk': 'Telur Ayam',
        'jumlah': '1 Tray',
        'total': 40000,
        'status': 'Siap Kirim',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5E9),
      appBar: AppBar(
        title: const Text('Kelola Pesanan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyPesananToko.length,
        itemBuilder: (context, index) {
          final pesanan = dummyPesananToko[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID Pesanan: ${pesanan['id_pesanan']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  const SizedBox(height: 4),
                  Text('Pembeli: ${pesanan['nama_pembeli']}',
                      style: const TextStyle(fontFamily: 'Poppins')),
                  Text('Produk: ${pesanan['produk']} (${pesanan['jumlah']})',
                      style: const TextStyle(fontFamily: 'Poppins')),
                  Text('Total: Rp ${pesanan['total']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontFamily: 'Poppins')),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getStatusColor(pesanan['status']),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        pesanan['status'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF5D844A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.grid_view), label: 'Produk'),
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                label: 'Kelola Pesanan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profil Usaha'),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu Konfirmasi':
        return Colors.orange;
      case 'Sedang Dikemas':
        return Colors.blue;
      case 'Siap Kirim':
        return Colors.purple;
      case 'Terkirim':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
