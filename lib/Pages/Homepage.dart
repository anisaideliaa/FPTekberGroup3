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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cart.CartProvider cartProvider = cart.CartProvider();
  int _selectedIndex = 0;
  String searchQuery = '';

  void _onItemTapped(int index) async {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        await Navigator.pushNamed(context, '/riwayat_pesanan');
        setState(() => _selectedIndex = 0);
        break;
      case 2:
        await Navigator.pushNamed(context, '/profil_user');
        setState(() => _selectedIndex = 0);
        break;
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
              onCartTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(cartProvider: cartProvider),
                ),
              ),
              onSearchSubmit: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            MapSection(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Untuk Anda',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins')),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.tune, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('Filter Produk Yang Anda Cari',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontFamily: 'Poppins')),
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
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError)
                    return Text('Terjadi kesalahan: ${snapshot.error}');
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                    return const Center(
                        child: Text('Belum ada produk.',
                            style: TextStyle(fontFamily: 'Poppins')));

                  final produkList = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final namaProduk =
                        (data['nama'] ?? '').toString().toLowerCase();
                    return namaProduk.contains(searchQuery);
                  }).toList();

                  if (produkList.isEmpty) {
                    return const Center(
                      child: Text('Produk tidak ditemukan.',
                          style: TextStyle(fontFamily: 'Poppins')),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: produkList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.62,
                    ),
                    itemBuilder: (context, index) {
                      final doc = produkList[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final product = Product(
                        id: doc.id,
                        name: data['nama'] ?? '',
                        description: data['deskripsi'] ?? '',
                        price:
                            'Rp. ${data['harga']?.toStringAsFixed(0) ?? '0'}',
                        image: data['imageUrl'] ?? '🛒',
                        category: data['jenis'] ?? '',
                        weight: '${data['berat'] ?? 0} KG',
                        seller: data['penjual'] ??
                            'CV. Maju Jaya Hasil Tani, Blok M',
                      );

                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping), label: 'Pesanan'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
