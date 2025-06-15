import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/product_service.dart';

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

    switch (index) {
      case 0:
        break;
      case 1:
        print('Navigasi ke Kelola');
        break;
      case 2:
        print('Navigasi ke Barter');
        break;
      case 3:
        print('Navigasi ke Pesanan');
        break;
      case 4:
        await Navigator.pushNamed(context, '/profil_usaha');
        setState(() => _selectedIndex = 0);
        break;
      case 5:
        await Navigator.pushNamed(context, '/profil_user');
        setState(() => _selectedIndex = 0);
        break;
      case 6:
        await Navigator.pushNamed(context, '/riwayat_pesanan');
        setState(() => _selectedIndex = 0);
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
              await Navigator.pushNamed(context, '/tambah_produk');
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Kelola'),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: 'Barter'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Pesanan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Profil Usaha'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profil User'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
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
                    style: TextStyle(fontSize: 20)),
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
            final data = produkList[index].data() as Map<String, dynamic>;

            return Card(
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
                      child: const Icon(Icons.image,
                          size: 32, color: Colors.green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['nama'] ?? '-',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(data['deskripsi'] ?? '-',
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${data['harga']?.toStringAsFixed(0) ?? '0'}',
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
