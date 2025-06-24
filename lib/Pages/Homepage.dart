import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasar_tani_nelayan/Pages/ProfilUser.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart' as cart;
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/map_section.dart';
import '../widgets/search_bar_widget.dart';
import 'ProductDetailPage.dart';
import 'CartPage.dart';
import 'ProfilToko.dart';
import 'RiwayatPesanan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cart.CartProvider cartProvider = cart.CartProvider();
  int _selectedIndex = 0;
  String searchQuery = '';
  String? _filterOption;

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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth >= 1200
        ? 4
        : screenWidth >= 800
            ? 3
            : 2;
    final aspectRatio = screenWidth >= 1200
        ? 0.7
        : screenWidth >= 800
            ? 0.75
            : 0.62;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: CustomAppBar(title: 'Beranda'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWidget(
                cartProvider: cartProvider,
                onCartTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(cartProvider: cartProvider),
                    ),
                  );
                  setState(() {}); // ✅ update badge setelah balik dari CartPage
                },
                onSearchSubmit: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 12),
              MapSection(),
              const SizedBox(height: 20),
              const Text(
                'Untuk Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Filter Berdasarkan:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: _filterOption,
                      hint: const Text(
                        'Pilih Filter',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'terendah', child: Text('Harga Terendah')),
                        DropdownMenuItem(
                            value: 'tertinggi', child: Text('Harga Tertinggi')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _filterOption = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        _filterOption = null;
                      });
                    },
                    child: const Text('Reset Filter',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
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

                  List<QueryDocumentSnapshot> produkList =
                      snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final namaProduk =
                        (data['nama'] ?? '').toString().toLowerCase();
                    return namaProduk.contains(searchQuery);
                  }).toList();

                  if (_filterOption == 'terendah') {
                    produkList.sort(
                        (a, b) => (a['harga'] ?? 0).compareTo(b['harga'] ?? 0));
                  } else if (_filterOption == 'tertinggi') {
                    produkList.sort(
                        (a, b) => (b['harga'] ?? 0).compareTo(a['harga'] ?? 0));
                  }

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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final doc = produkList[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final product = Product(
                        id: doc.id,
                        name: data['nama'] ?? '',
                        description: data['deskripsi'] ?? '',
                        price: '${data['harga']?.toStringAsFixed(0) ?? '0'}',
                        image: data['imageUrl'] ?? '🛒',
                        category: data['jenis'] ?? '',
                        weight: '${data['berat'] ?? 0} KG',
                        seller: data['penjual'] ??
                            'CV. Maju Jaya Hasil Tani, Blok M',
                      );

                      return ProductCard(
                        product: product,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                product: product,
                                cartProvider: cartProvider,
                              ),
                            ),
                          );
                          setState(
                              () {}); // ✅ refresh badge setelah kembali dari detail
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
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
