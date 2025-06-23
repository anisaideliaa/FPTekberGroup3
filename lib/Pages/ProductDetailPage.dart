import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_app_bar.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final CartProvider cartProvider;

  const ProductDetailPage({
    Key? key,
    required this.product,
    required this.cartProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: CustomAppBar(title: 'Detail Produk'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child:
                    Text(product.image, style: const TextStyle(fontSize: 80))),
            const SizedBox(height: 16),
            Text(product.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Jenis: ${product.category}',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(product.price,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Deskripsi Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(product.description,
                style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 8),
            Text('Berat: ${product.weight}',
                style: const TextStyle(fontSize: 14)),
            Text('Toko: ${product.seller}',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      cartProvider.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Ditambahkan ke keranjang'),
                            backgroundColor: Colors.green[700]),
                      );
                    },
                    child: const Text('Keranjang'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Produk dibeli'),
                            backgroundColor: Colors.green[700]),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700]),
                    child: const Text(
                      'Beli Sekarang',
                      style: TextStyle(
                        color: Colors.white, // warna tulisan putih
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
