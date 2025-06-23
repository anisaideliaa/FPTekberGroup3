import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/product_service.dart';
import 'EditProduk.dart';

class TokoHomePage extends StatefulWidget {
  const TokoHomePage({super.key});

  @override
  State<TokoHomePage> createState() => _TokoHomePageState();
}

class _TokoHomePageState extends State<TokoHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      await Navigator.pushNamed(context, '/profil_toko');
      setState(() => _selectedIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Kelola Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Profil Usaha'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      // Produk
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
                  const Text('Produk Masih Kosong', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/tambah_produk');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    child: const Text('Tambahkan Produk'),
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

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProdukPage(id: doc.id, data: data),
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
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.image, size: 32, color: Colors.green),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['nama'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(data['deskripsi'] ?? '-', maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${data['harga']?.toStringAsFixed(0) ?? '0'}',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
    } else if (_selectedIndex == 1) {
      // Kelola Pesanan & Riwayat
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Riwayat Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('riwayat_pesanan').orderBy('tanggal', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Belum ada riwayat pesanan.'));
                }

                final pesananList = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: pesananList.length,
                  itemBuilder: (context, index) {
                    final data = pesananList[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: Text(data['nama_pelanggan'] ?? 'Pelanggan'),
                      subtitle: Text('Total: Rp ${data['total']?.toStringAsFixed(0) ?? '0'}'),
                      trailing: Text(data['status'] ?? 'Belum Dikirim'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    } else {
      // Default halaman
      return const Center(child: Text("Halaman belum tersedia"));
    }
  }
}
