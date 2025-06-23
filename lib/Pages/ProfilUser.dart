import 'package:flutter/material.dart';

// Impor halaman-halaman yang akan dituju oleh Bottom Nav Bar di halaman ini
import 'package:pasar_tani_nelayan/Pages/Homepage.dart'; // Untuk navigasi kembali ke Beranda
import 'package:pasar_tani_nelayan/Pages/RiwayatPesanan.dart'; // Untuk navigasi ke Pesanan

class ProfilUserPage extends StatefulWidget {
  const ProfilUserPage({super.key});

  @override
  State<ProfilUserPage> createState() => _ProfilUserPageState();
}

class _ProfilUserPageState extends State<ProfilUserPage> {
  int _selectedIndex = 2; // 'Profil' adalah index 2 di navbar ini

  // Widget pembantu untuk membuat item menu
  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String routeName}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF5A6543)),
        title: Text(title, style: const TextStyle(fontFamily: 'Poppins')),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Beranda
        Navigator.pushReplacementNamed(context, 'homepage');
        break;
      case 1: // Pesanan
        Navigator.pushReplacementNamed(context, '/riwayat_pesanan');
        break;
      case 2: // Profil
        // Sudah di halaman ini, tidak perlu navigasi
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5E9),
      appBar: AppBar(
        title: const Text('Profil Anda'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF5D844A),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'PETER CROUCH',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 5),
            const Text(
              'Pengguna Biasa',
              style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 30),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'Informasi Akun',
              routeName: '/informasi_akun',
            ),
            _buildMenuItem(
              context,
              icon: Icons.location_on_outlined,
              title: 'Alamat Pengguna',
              routeName: '/alamat_pengguna',
            ),
            _buildMenuItem(
              context,
              icon: Icons.account_balance,
              title: 'Informasi Bank',
              routeName: '/informasi_bank',
            ),
            _buildMenuItem(
              context,
              icon: Icons.lock_outline,
              title: 'Ganti Kata Sandi',
              routeName: '/ganti_password',
            ),
            const SizedBox(height: 20),
          ],
        ),
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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            // PERBAIKAN DI SINI: Bungkus IconData dengan widget Icon()
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
