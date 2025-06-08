import 'package:flutter/material.dart';

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
              // Aksi ketika icon gerigi ditekan
              // Contoh: Navigator.pushNamed(context, '/settings_page');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengaturan ditekan!')),
              );
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
            _buildInfoCard(context, 'Informasi Akun', '/informasi_akun'),
            _buildInfoCard(context, 'Identitas Pemilik',
                '/navigasi_profil_user'), // Ini mungkin mengarah ke BusinessProfilePage
            _buildInfoCard(context, 'Informasi Rekening', '/informasi_bank'),
            _buildInfoCard(context, 'Informasi Toko',
                '/edit_profile'), // Ini mungkin mengarah ke EditProfile
            _buildInfoCard(context, 'Komunitas Tani',
                '/komunitas_tani'), // Anda perlu menambahkan rute ini
            const SizedBox(height: 30), // Spasi di bagian bawah
          ],
        ),
      ),
      bottomNavigationBar:
          _buildBottomNavigationBar(context), // Meneruskan context
    );
  }

  // Widget pembantu untuk membuat kartu informasi
  Widget _buildInfoCard(BuildContext context, String title, String? routeName) {
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
            if (routeName != null) {
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
        // Handle navigasi di sini menggunakan named routes
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
            // Rute untuk Barter, Anda perlu menambahkannya jika belum ada
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
}
