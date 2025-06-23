import 'package:flutter/material.dart';

// Impor halaman-halaman yang akan dituju oleh Bottom Nav Bar di halaman ini
import 'package:pasar_tani_nelayan/Pages/Homepage.dart'; // Untuk navigasi kembali ke Beranda
import 'package:pasar_tani_nelayan/Pages/ProfilUser.dart'; // Untuk navigasi ke Profil

class RiwayatPesananPage extends StatefulWidget {
  const RiwayatPesananPage({super.key});

  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  int _selectedIndex = 1; // 'Pesanan' adalah index 1 di navbar ini

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Beranda
        // Menggunakan pushReplacementNamed agar tidak menumpuk RiwayatPesananPage jika sudah ada
        Navigator.pushReplacementNamed(context, 'homepage');
        break;
      case 1: // Pesanan
        // Sudah di halaman ini, tidak perlu navigasi
        break;
      case 2: // Profil
        // Menggunakan pushReplacementNamed agar tidak menumpuk RiwayatPesananPage jika sudah ada
        Navigator.pushReplacementNamed(context, '/profil_user');
        break;
    }
  }

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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading:
                  const Icon(Icons.shopping_basket, color: Color(0xFF5A6543)),
              title: Text(item['produk'],
                  style: const TextStyle(fontFamily: 'Poppins')),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jumlah: ${item['jumlah']}',
                      style: const TextStyle(fontFamily: 'Poppins')),
                  Text('Harga: Rp ${item['harga']}',
                      style: const TextStyle(fontFamily: 'Poppins')),
                  Text('Tanggal: ${item['tanggal']}',
                      style: const TextStyle(fontFamily: 'Poppins')),
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
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12, fontFamily: 'Poppins'),
                ),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Detail pesanan ${item['produk']}')),
                );
              },
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
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          currentIndex: _selectedIndex, // Menggunakan _selectedIndex
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping), label: 'Pesanan'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
