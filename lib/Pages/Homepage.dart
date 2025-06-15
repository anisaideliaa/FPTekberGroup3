import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart' as cart;
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/map_section.dart';
import '../widgets/search_bar_widget.dart';
import 'ProductDetailPage.dart';
import 'CartPage.dart';
import 'ProfilUser.dart';
import 'RiwayatPesanan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cart.CartProvider cartProvider = cart.CartProvider();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RiwayatPesananPage()),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilUserPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: CustomAppBar(title: 'Beranda'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(
              cartProvider: cartProvider,
              onCartTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(cartProvider: cartProvider),
                  ),
                );
              },
            ),
            MapSection(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Untuk Anda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.tune, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Filter Produk Yang Anda Cari',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Icon(Icons.keyboard_arrow_down,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<QuerySnapshot>(
                stream: ProductService().ambilSemuaProduk(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Terjadi kesalahan: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Belum ada produk.'));
                  }

                  final produkList = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: produkList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.62,
                    ),
                    itemBuilder: (context, index) {
                      final data =
                          produkList[index].data() as Map<String, dynamic>;
                      final product = Product(
                        name: data['nama'] ?? '',
                        description: data['deskripsi'] ?? '',
                        price:
                            'Rp. ${data['harga']?.toStringAsFixed(0) ?? '0'}',
                        image:
                            '🛒', // atau tambahkan URL image di database kalau ada
                        category: data['jenis'] ?? '',
                        weight: '${data['berat']} KG',
                      );

                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: product,
                                cartProvider: cartProvider,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'Dikirim &\nDiproses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
