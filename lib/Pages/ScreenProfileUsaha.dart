import 'package:flutter/material.dart';
import 'package:pasar_tani_nelayan/Pages/LoginPage.dart';

class ScreenProfileUsaha extends StatelessWidget {
  const ScreenProfileUsaha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF9F7E8), // Warna latar belakang sesuai gambar
      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF9F7E8), // Sesuaikan dengan latar belakang
        elevation: 0, // Hapus bayangan AppBar
        title: const Text(
          'Profil Usaha',
          style: TextStyle(
            color: Colors.black, // Warna teks hitam
            fontWeight: FontWeight.bold,
            fontSize: 22, // Ukuran font sesuai perkiraan
            fontFamily: 'Poppins', // Menggunakan font Poppins
          ),
        ),
        centerTitle: false, // Teks tidak di tengah
        actions: [
          IconButton(
            icon: const Icon(Icons.settings,
                color: Color(0xFF5D844A), size: 30), // Icon gerigi
            onPressed: () {
              _showLogoutConfirmationDialog(
                  context); // Panggil fungsi notifikasi logout
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
            // Bagian Logo Usaha
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Latar belakang putih untuk lingkaran
                border: Border.all(
                    color: const Color(0xFF5D844A), width: 2), // Border hijau
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo_pasar_tani.png', // Ganti dengan path gambar logo Anda
                  fit: BoxFit.cover, // Sesuaikan sesuai kebutuhan
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
            // Daftar Pilihan Informasi
            _buildInfoCard(context, 'Informasi Akun', '/profil_usaha'),
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
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  // Widget pembantu untuk membuat kartu informasi
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
        // Gunakan Material untuk ripple effect
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

  // Widget untuk Bottom Navigation Bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF5D844A), // Warna hijau gelap
      selectedItemColor: Colors.white, // Warna ikon/teks terpilih
      unselectedItemColor:
          Colors.white.withOpacity(0.7), // Warna ikon/teks tidak terpilih
      type: BottomNavigationBarType.fixed, // Tetap saat item banyak
      selectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
      currentIndex: 4, // 'Profil' adalah item terakhir
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          label: 'Produk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons
              .settings_applications), // Icon placeholder, ganti jika ada yang lebih cocok
          label: 'Kelola',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz), // Icon barter
          label: 'Barter',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined), // Icon pesanan
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        // Handle navigasi di sini
        switch (index) {
          case 0:
            Navigator.pushNamed(
                context, '/'); // Atau rute khusus untuk halaman produk
            break;
          case 1:
            Navigator.pushNamed(
                context, '/tambah_produk'); // Kelola -> Tambah Produk
            break;
          case 2:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigasi ke halaman Barter')),
            );
            break;
          case 3:
            Navigator.pushNamed(
                context, '/riwayat_pesanan'); // Pesanan -> Riwayat Pesanan
            break;
          case 4:
            // Sudah di halaman profil, tidak perlu navigasi ulang
            break;
        }
      },
    );
  }

  // Fungsi untuk menampilkan notifikasi Komunitas Tani
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

  // Fungsi baru untuk menampilkan dialog konfirmasi logout
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Bisa dismiss dengan tap di luar dialog
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
                    // Navigasi ke halaman login dan hapus semua rute sebelumnya
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                    // Atau jika menggunakan named routes:
                    // Navigator.pushNamedAndRemoveUntil(
                    //   context,
                    //   '/login',
                    //   (Route<dynamic> route) => false,
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Warna tombol putih
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFF5D844A), // Warna teks tombol hijau
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
}
