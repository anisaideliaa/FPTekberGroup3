import 'package:flutter/material.dart';

class TokoHomePage extends StatefulWidget {
  const TokoHomePage({super.key});

  @override
  State<TokoHomePage> createState() => _TokoHomePageState();
}

class _TokoHomePageState extends State<TokoHomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _produk = [];

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Produk - tidak perlu navigasi, tetap di sini
        break;
      case 1:
        // Kelola
        print('Navigasi ke Kelola');
        break;
      case 2:
        // Barter
        print('Navigasi ke Barter');
        break;
      case 3:
        // Pesanan
        print('Navigasi ke Pesanan');
        break;
      case 4:
        // Profil Usaha
        await Navigator.pushNamed(context, '/profil_usaha');
        setState(() => _selectedIndex = 0);
        break;
      case 5:
        // Profil User
        await Navigator.pushNamed(context, '/profil_user');
        setState(() => _selectedIndex = 0);
        break;
      case 6:
        // Riwayat Pesanan
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
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Kelola'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Barter'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Profil Usaha'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profil User'),
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
    if (_produk.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Produk Masih Kosong',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/tambah_produk');
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _produk.add(result);
                  });
                }
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
    } else {
      return ListView.builder(
        itemCount: _produk.length,
        itemBuilder: (context, index) {
          final product = _produk[index];
          return ListTile(
            title: Text(product['nama'] ?? ''),
            subtitle: Text(product['deskripsi'] ?? ''),
          );
        },
      );
    }
  }
}
