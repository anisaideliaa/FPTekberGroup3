import 'package:flutter/material.dart';

class TokoHomePage extends StatefulWidget {
  const TokoHomePage({super.key});

  @override
  State<TokoHomePage> createState() => _TokoHomePageState();
}

class _TokoHomePageState extends State<TokoHomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _produk = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
              final result = await Navigator.pushNamed(context, '/tambah_produk');
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
                final result = await Navigator.pushNamed(context, '/tambah_produk');
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
            title: Text(product['nama'] ?? ''), // Gunakan null safety operator ??
            subtitle: Text(product['deskripsi'] ?? ''), // Gunakan null safety operator ??
            // ... tampilkan data produk lainnya
          );
        },
      );
    }
  }
}