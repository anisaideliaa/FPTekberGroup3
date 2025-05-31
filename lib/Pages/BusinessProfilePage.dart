import 'package:flutter/material.dart';
import 'package:pasar_tani_nelayan/Pages/EditProfile.dart'; // <--- Import EditProfilePage

class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({Key? key}) : super(key: key);

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  int _selectedIndex = 4; // Tetap 4, karena ini adalah halaman profil

  @override
  void initState() {
    super.initState();
    _selectedIndex = 4;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Produk (Shopping Cart Icon)
        Navigator.pop(context, 0); // Mengembalikan 0 (indeks tab Produk)
        break;
      case 1: // Kelola
        print('Navigasi ke Kelola');
        // Contoh: Navigator.pushNamed(context, '/kelola_page');
        break;
      case 2: // Barter
        print('Navigasi ke Barter');
        // Contoh: Navigator.pushNamed(context, '/barter_page');
        break;
      case 3: // Pesanan
        print('Navigasi ke Pesanan');
        // Contoh: Navigator.pushNamed(context, '/pesanan_page');
        break;
      case 4: // Profil (Anda sudah berada di halaman ini)
        print('Anda sudah di halaman Profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profil Usaha',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF8BC34A)),
            onPressed: () {
              // TODO: Handle settings icon tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  color: Colors.white,
                  image: const DecorationImage(
                    image: AssetImage('assets/pasartani_logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'CV. Maju Jaya Hasil Tani, Blok M',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // --- Modifikasi _buildProfileOption di sini ---
            _buildProfileOption(context, 'Informasi Akun', () {
              Navigator.pushNamed(
                  context, '/edit_profile'); // Navigasi ke EditProfilePage
            }),
            _buildProfileOption(context, 'Identitas Pemilik', () {
              print('Tapped on Identitas Pemilik');
              // Tambahkan navigasi ke halaman Identitas Pemilik
            }),
            _buildProfileOption(context, 'Informasi Rekening', () {
              print('Tapped on Informasi Rekening');
              // Tambahkan navigasi ke halaman Informasi Rekening
            }),
            _buildProfileOption(context, 'Informasi Toko', () {
              print('Tapped on Informasi Toko');
              // Tambahkan navigasi ke halaman Informasi Toko
            }),
            _buildProfileOption(context, 'Komunitas Tani', () {
              print('Tapped on Komunitas Tani');
              // Tambahkan navigasi ke halaman Komunitas Tani
            }),
            // --- Akhir Modifikasi ---
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Kelola',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Barter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  // Modifikasi _buildProfileOption untuk menerima onTap Callback
  Widget _buildProfileOption(
      BuildContext context, String title, VoidCallback onTapAction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapAction, // Gunakan onTapAction yang diterima
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
