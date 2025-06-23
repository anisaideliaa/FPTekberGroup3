import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/product_service.dart';
import 'EditProduk.dart'; // Pastikan path ini benar

// Import halaman yang akan dinavigasi keluar
// import 'package:pasar_tani_nelayan/pages/KelolaPesananPage.dart'; // Tidak perlu diimpor jika hanya navigasi
// import 'package:pasar_tani_nelayan/pages/ProfileUsaha.dart'; // Tidak perlu diimpor jika hanya navigasi

class TokoHomePage extends StatefulWidget {
  const TokoHomePage({super.key});

  @override
  State<TokoHomePage> createState() => _HomeTokoState();
}

class _HomeTokoState extends State<TokoHomePage> {
  // _selectedIndex di HomeToko ini hanya untuk tab 'Produk'
  // Karena tab lain akan menavigasi ke halaman terpisah.
  int _selectedIndex =
      0; // Produk (index 0) akan selalu terpilih secara visual di sini.

  // _widgetOptions sekarang hanya berisi konten untuk tab 'Produk'.
  // Tab lain akan ditangani oleh Navigator.pushNamed.
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      _buildProdukSection(), // Index 0: Halaman Produk
      // Kosongkan atau gunakan placeholder untuk tab lain jika tidak dikelola oleh IndexedStack
      const SizedBox.shrink(), // Placeholder untuk Kelola Pesanan (Index 1)
      const SizedBox.shrink(), // Placeholder untuk Profil Usaha (Index 2)
    ];
  }

  void _onItemTapped(int index) async {
    // Tetapkan index yang dipilih secara visual untuk HomeToko itu sendiri
    // agar 'Produk' tetap terpilih jika kita kembali.
    setState(() => _selectedIndex = index); // Ini akan selalu 0 di HomeToko

    switch (index) {
      case 0: // Produk
        // Sudah di halaman ini, tidak perlu navigasi
        break;
      case 1: // Untuk tab 'Kelola Pesanan'
        await Navigator.pushNamed(context, '/kelola_pesanan');
        // Setelah kembali dari KelolaPesananPage, reset selectedIndex ke Produk
        setState(() => _selectedIndex = 0);
        break;
      case 2: // Untuk tab 'Profil Usaha'
        await Navigator.pushNamed(context, '/profil_usaha');
        // Setelah kembali dari ProfileUsaha, reset selectedIndex ke Produk
        setState(() => _selectedIndex = 0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F3E7), // Warna latar belakang sesuai desain
      appBar: AppBar(
        title: const Text(
          'CV. Maju Jaya Hasil Tani, Blok M',
          // Gaya teks AppBar sudah didefinisikan di MaterialApp theme
        ),
        actions: [
          // Tampilkan tombol tambah hanya jika sedang di tab "Produk" (index 0)
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(
                  Icons.add), // Warna icon sudah diatur di MaterialApp theme
              onPressed: () async {
                await Navigator.pushNamed(context, '/tambah_produk');
              },
            ),
        ],
      ),
      // Body hanya akan menampilkan _buildProdukSection karena tab lain akan navigasi keluar
      body:
          _buildProdukSection(), // Hanya menampilkan konten produk secara langsung
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(
              0xFF5D844A), // Background color for the whole bottom bar container
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors
              .transparent, // Membuat navbar transparan agar BoxDecoration terlihat
          elevation: 0, // Menghilangkan shadow default navbar
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          // currentIndex selalu 0 karena 'Produk' adalah satu-satunya tab yang dikelola secara internal.
          // Tab lain akan menavigasi keluar.
          currentIndex: 0, // Selalu tunjukkan 'Produk' terpilih di HomeToko
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
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

  // Widget untuk Halaman Produk (dipindahkan kembali sebagai method)
  static Widget _buildProdukSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: ProductService().ambilSemuaProduk(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Produk Masih Kosong',
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppins')),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/tambah_produk');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D844A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Tambahkan Produk',
                      style: TextStyle(fontFamily: 'Poppins')),
                ),
              ],
            ),
          );
        }

        final produkList = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: produkList.length,
          itemBuilder: (context, index) {
            final doc = produkList[index];
            final data = doc.data() as Map<String, dynamic>;
            final imageUrl = data['imageUrl'] as String?;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProdukPage(id: doc.id, data: data),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported,
                                          size: 32, color: Colors.grey),
                                ),
                              )
                            : const Icon(Icons.image,
                                size: 32, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['nama'] ?? '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Poppins')),
                            const SizedBox(height: 4),
                            Text(data['deskripsi'] ?? '-',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontFamily: 'Poppins')),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${data['harga']?.toStringAsFixed(0) ?? '0'}',
                              style: const TextStyle(
                                  color: Color(0xFF5D844A),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // _buildKelolaPesananSection ini tidak lagi menjadi konten di IndexedStack HomeToko,
  // melainkan harus menjadi isi dari KelolaPesananPage.dart
  static Widget _buildKelolaPesananSection() {
    // Placeholder karena KelolaPesananPage akan memiliki UI sendiri
    return const Center(child: Text("Halaman Kelola Pesanan (Konten Asli)"));
  }
}
