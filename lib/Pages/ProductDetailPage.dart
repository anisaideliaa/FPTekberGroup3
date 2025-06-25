import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_app_bar.dart';
import 'CheckoutPage.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final CartProvider cartProvider;

  const ProductDetailPage({
    Key? key,
    required this.product,
    required this.cartProvider,
  }) : super(key: key);

  Widget _buildImage(double size) {
    if (product.image.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          product.image,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else if (product.image.length > 100) {
      try {
        final bytes = base64Decode(product.image);
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            bytes,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        );
      } catch (e) {
        return Text('❌', style: TextStyle(fontSize: size));
      }
    } else {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(product.image, style: TextStyle(fontSize: size * 0.6)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final imageSize = isMobile ? 180.0 : 240.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: CustomAppBar(title: 'Detail Produk'),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: isMobile ? 16 : 64, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildImage(imageSize)),
            const SizedBox(height: 24),
            Text(
              product.name,
              style: TextStyle(
                fontSize: isMobile ? 22 : 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp. ${product.price}',
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(product.category,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi Produk',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(product.description,
                style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 8),
            Text('Berat: ${product.weight}',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.store, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    product.seller,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      cartProvider.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Ditambahkan ke keranjang'),
                          backgroundColor: Colors.green[700],
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart, color: Colors.green),
                    label: const Text(
                      'Keranjang',
                      style: TextStyle(color: Colors.green),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cartProvider.clearCart();
                      cartProvider.addToCart(product);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CheckoutPage(cartProvider: cartProvider),
                        ),
                      );
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text(
                      'Beli Sekarang',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
