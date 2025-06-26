import 'package:flutter/material.dart';
import 'package:pasar_tani_nelayan/Pages/LoginPage.dart';

// Import halaman-halaman yang akan dituju oleh Bottom Nav Bar di halaman ini
import 'package:pasar_tani_nelayan/Pages/HomeToko.dart'; // Untuk navigasi kembali ke Beranda (Produk Toko)
import 'package:pasar_tani_nelayan/Pages/KelolaPesananPage.dart'; // Untuk navigasi ke Kelola Pesanan Toko

class ProfileUsaha extends StatefulWidget {
  // Ubah menjadi StatefulWidget
  const ProfileUsaha({super.key});

  @override
  State<ProfileUsaha> createState() => _ProfileUsahaState();
}

class _ProfileUsahaState extends State<ProfileUsaha> {
  int _selectedIndex = 2; // 'Profil Usaha' adalah index 2 di navbar ini

  // Widget pembantu untuk membuat kartu informasi (tetap sama)
  Widget _buildInfoCard(BuildContext context, String title, String? routeName,
      {VoidCallback? onTapCustom}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // Pergeseran bayangan
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (onTapCustom != null) {
              onTapCustom();
            } else if (routeName != null) {
              Navigator.pushNamed(context, routeName);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Aksi untuk $title belum ditentukan.')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan notifikasi Komunitas Tani (tetap sama)
  void _showKomunitasTaniNotification(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF5D844A),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Link group whatsapp komunitas tani berhasil terkirim, apabila belum mendapatkan link grup whatsapp, klik tombol dibawah ini!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Membuka Link Komunitas Tani (WhatsApp)')),
                    );
                    Navigator.of(dialogContext).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                  ),
                  child: const Text(
                    'Link Komunitas Tani',
                    style: TextStyle(
                      color: Color(0xFF5D844A),
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi logout (tetap sama)
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF5D844A), // Warna hijau gelap
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ingin logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Tutup dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFF5D844A),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Produk
        Navigator.pushReplacementNamed(context, '/toko_homepage');
        break;
      case 1: // Kelola Pesanan
        Navigator.pushReplacementNamed(context, '/kelola_pesanan');
        break;
      case 2: // Profil Usaha
        // Sudah di halaman ini, tidak perlu navigasi
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7E8),
      appBar: AppBar(
        title: const Text('Profil Usaha'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFF5D844A), width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo_pasar_tani.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'CV. Maju Jaya Hasil Tani, Blok M',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(context, 'Informasi Akun', '/informasi_usaha'),
            _buildInfoCard(context, 'Identitas Pemilik', '/identitas_pemilik'),
            _buildInfoCard(
                context, 'Informasi Rekening', '/informasi_rekening'),
            _buildInfoCard(context, 'Informasi Toko', '/informasi_toko'),
            _buildInfoCard(
              context,
              'Komunitas Tani',
              null,
              onTapCustom: () {
                _showKomunitasTaniNotification(context);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // BottomNavigationBar DITAMBAHKAN KEMBALI DI SINI
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF5D844A), // Warna hijau gelap
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Membuat background transparan
          elevation: 0, // Menghilangkan shadow
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          currentIndex: _selectedIndex, // Menggunakan state internal
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
}
