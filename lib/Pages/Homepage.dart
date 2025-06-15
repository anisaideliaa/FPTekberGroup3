import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart' as cart;
import '../widgets/product_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/map_section.dart';
import '../widgets/search_bar_widget.dart';
import 'ProductDetailPage.dart';
import 'CartPage.dart';
import 'ProfilUser.dart';
import 'RiwayatPesanan.dart'; // ✅ Tambahan import halaman

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cart.CartProvider cartProvider = cart.CartProvider();
  int _selectedIndex = 0;

  final List<Product> products = [
    Product(
      name: 'Jagung Kristal Cap Merpati 1 KG',
      price: 'Rp. 15.000,00',
      image: '🌽',
      category: 'Paling Laku',
      weight: '1 KG',
      description:
          'Jagung Kristal adalah pakan berkualitas tinggi yang dirancang khusus untuk memenuhi kebutuhan nutrisi burung merpati.',
    ),
    Product(
      name: 'Beras Pinpin Eksklusif 5 KG',
      price: 'Rp. 85.000,00',
      image: '🍚',
      category: 'Termurah Surabaya',
      weight: '5 KG',
      description:
          'Beras premium berkualitas tinggi dengan tekstur pulen dan aroma yang harum.',
    ),
    Product(
      name: 'Ubi Ungu Desa Super 10 KG',
      price: 'Rp. 130.000,00',
      image: '🍠',
      category: 'Paling Laku',
      weight: '10 KG',
      description: 'Ubi ungu segar dari petani lokal dengan kualitas terbaik.',
    ),
    Product(
      name: 'Biji Kopi Hitam Premium 1KG',
      price: 'Rp. 60.000,00',
      image: '☕',
      category: 'Paling Laku',
      weight: '1 KG',
      description:
          'Biji kopi pilihan dengan cita rasa yang khas dan aroma yang menggoda.',
    ),
    Product(
      name: 'Kangkung Fresh 500Gram',
      price: 'Rp. 9.000,00',
      image: '🥬',
      category: '',
      weight: '500 Gram',
      description: 'Kangkung segar langsung dari kebun petani lokal.',
    ),
    Product(
      name: 'Cengkeh Kering Cap Bagus 5KG',
      price: 'Rp. 550.000,00',
      image: '🌿',
      category: '',
      weight: '5 KG',
      description:
          'Cengkeh kering berkualitas tinggi untuk berbagai keperluan.',
    ),
    Product(
      name: 'Minyak Kepala Sawit 2Liter',
      price: 'Rp. 35.534,00',
      image: '🥥',
      category: '',
      weight: '2 Liter',
      description: 'Minyak sawit murni untuk kebutuhan memasak sehari-hari.',
    ),
    Product(
      name: 'Kentang Ukuran Sedang 1KG',
      price: 'Rp. 15.000,00',
      image: '🥔',
      category: 'Paling Laku',
      weight: '1 KG',
      description: 'Kentang segar ukuran sedang dengan kualitas terbaik.',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RiwayatPesananPage(),
        ),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilUserPage(),
        ),
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
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
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
