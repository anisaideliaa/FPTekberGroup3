import 'package:flutter/material.dart';
// import 'package:pasar_tani_nelayan/Pages/TambahProduk.dart'; // Pastikan ini diimport jika digunakan di sini

class TokoHomePage extends StatefulWidget {
  const TokoHomePage({super.key});

  @override
  State<TokoHomePage> createState() => _TokoHomePageState();
}

class _TokoHomePageState extends State<TokoHomePage> {
  int _selectedIndex = 0; // Default ke 'Produk' saat pertama kali dimuat
  List<Map<String, dynamic>> _produk = [];

  @override
  void initState() {
    super.initState();
    // _selectedIndex sudah diinisialisasi di atas
  }

  void _onItemTapped(int index) async {
    // Ubah menjadi async jika Anda ingin menunggu pushNamed
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Produk
        // Jika sudah di tab produk, tidak perlu navigasi ekstra,
        // hanya pastikan body menampilkan produk.
        // Jika ini bukan halaman produk utama, Anda bisa menavigasi ke sana.
        break;
      case 1: // Kelola
        // Contoh: await Navigator.pushNamed(context, '/kelola_page');
        print('Navigasi ke Kelola');
        break;
      case 2: // Barter
        // Contoh: await Navigator.pushNamed(context, '/barter_page');
        print('Navigasi ke Barter');
        break;
      case 3: // Pesanan
        // Contoh: await Navigator.pushNamed(context, '/pesanan_page');
        print('Navigasi ke Pesanan');
        break;
      case 4: // Profil
        // --- Bagian PENTING: Menangkap hasil kembali dari BusinessProfilePage ---
        final returnedIndex =
            await Navigator.pushNamed(context, '/profil_usaha');
        if (returnedIndex != null && returnedIndex is int) {
          // Jika BusinessProfilePage mengembalikan index, set _selectedIndex sesuai itu
          setState(() {
            _selectedIndex = returnedIndex;
          });
        }
        // Jika tidak ada index yang dikembalikan, atau jika tidak kembali dari profil,
        // _selectedIndex akan tetap pada index 4 (Profil) atau yang terakhir.
        // Anda mungkin ingin secara eksplisit mengaturnya kembali ke 0 jika ini yang diinginkan:
        // setState(() {
        //   _selectedIndex = 0; // Kembali ke produk setelah selesai dari profil
        // });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV. Maju Jaya Hasil Tani, Blok M'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, '/tambah_produk');
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  _produk.add(result);
                });
              }
            },
          ),
        ],
      ),
      body: _buildBody(), // Panggil fungsi _buildBody() untuk memisahkan logika
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

  Widget _buildBody() {
    // Konten body ini akan tetap terpampang di bawah App/Bottom Bar.
    // Jika Anda ingin mengubah konten body berdasarkan _selectedIndex,
    // Anda perlu membuat daftar widget untuk setiap tab di sini.
    if (_produk.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Produk Masih Kosong',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, '/tambah_produk');
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _produk.add(result);
                  });
                }
              },
              child: const Text('Tambahkan Produk'),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _produk.length,
        itemBuilder: (context, index) {
          final product = _produk[index];
          return ListTile(
            title: Text(product['nama'] ?? ''),
            subtitle: Text(product['deskripsi'] ?? ''),
            // ... tampilkan data produk lainnya
          );
        },
      );
    }
  }
}
