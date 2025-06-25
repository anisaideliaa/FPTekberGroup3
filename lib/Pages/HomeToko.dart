import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // <<< Tambahkan import ini
import '../services/product_service.dart';
import 'EditProduk.dart'; // Pastikan path ini benar

class TokoHomePage extends StatefulWidget {
  const TokoHomePage({super.key});

  @override
  State<TokoHomePage> createState() => _HomeTokoState();
}

class _HomeTokoState extends State<TokoHomePage> {
  int _selectedIndex =
      0; // Produk (index 0) akan selalu terpilih secara visual di sini.

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) async {
    setState(() => _selectedIndex = index); // Ini akan selalu 0 di HomeToko

    switch (index) {
      case 0: // Produk
        break;
      case 1: // Untuk tab 'Kelola Pesanan'
        await Navigator.pushNamed(context, '/kelola_pesanan');
        setState(() => _selectedIndex = 0);
        break;
      case 2: // Untuk tab 'Profil Usaha'
        await Navigator.pushNamed(context, '/profil_toko');
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
        ),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.pushNamed(context, '/tambah_produk');
                // Setelah kembali dari TambahProduk, kita bisa memuat ulang data
                // agar produk baru langsung terlihat. setState kosong sudah cukup.
                setState(() {});
              },
            ),
        ],
      ),
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

  Widget _buildProdukSection() {
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
            final imageUrl = data['imageUrl'] as String?; // Ambil URL gambar

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
                      // --- Display Image Here ---
                      Container(
                        width: 80, // Ukuran gambar yang sedikit lebih besar
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported,
                                          size: 40, color: Colors.grey),
                                ),
                              )
                            : const Icon(Icons.image,
                                size: 40, color: Colors.grey),
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
                      // Tambahkan ikon hapus
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeleteProduct(context, doc.id, imageUrl);
                        },
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

  // Fungsi untuk konfirmasi penghapusan produk
  void _confirmDeleteProduct(
      BuildContext context, String productId, String? imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
                await _deleteProduct(productId, imageUrl);
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus produk dari Firestore dan gambarnya dari Storage
  Future<void> _deleteProduct(String productId, String? imageUrl) async {
    try {
      // Hapus gambar dari Firebase Storage jika ada
      if (imageUrl != null && imageUrl.isNotEmpty) {
        Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
        print('Gambar berhasil dihapus dari Storage.');
      }

      // Hapus dokumen produk dari Firestore
      await ProductService().hapusProduk(productId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil dihapus')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus produk: $e')),
        );
      }
      print('Error deleting product: $e');
    }
  }
}
