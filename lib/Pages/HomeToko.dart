import 'dart:convert'; // untuk base64Decode
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/product_service.dart';
import 'EditProduk.dart';

class TokoHomePage extends StatefulWidget {
  const TokoHomePage({super.key});

  @override
  State<TokoHomePage> createState() => _HomeTokoState();
}

class _HomeTokoState extends State<TokoHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: AppBar(
        title: const Text('CV. Maju Jaya Hasil Tani, Blok M'),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.pushNamed(context, '/tambah_produk');
              },
            ),
        ],
      ),
      body: _buildProdukSection(),
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
          currentIndex: 0,
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

  void _onItemTapped(int index) async {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 1:
        await Navigator.pushNamed(context, '/kelola_pesanan');
        setState(() => _selectedIndex = 0);
        break;
      case 2:
        await Navigator.pushNamed(context, '/profil_toko');
        setState(() => _selectedIndex = 0);
        break;
    }
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
            final imageBase64 = data['imageBase64'] as String?;

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
                        child: imageBase64 != null && imageBase64.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  base64Decode(imageBase64),
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
}
