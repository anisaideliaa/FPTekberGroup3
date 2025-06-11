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

  Widget _buildWeightOption(String weight, String label) {
    return Column(
      children: [
        Text(
          weight,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDimensionOption(String dimension, String label) {
    return Column(
      children: [
        Text(
          dimension,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F3E7),
      appBar: CustomAppBar(
        title: 'PASAR TANI',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Colors.green[700],
              child: Text(
                'CV. Maju Jaya Hasil Tani, Blok M',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Product images carousel
            Container(
              height: 250,
              child: PageView(
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        product.image,
                        style: TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '🌽',
                        style: TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '🌾',
                        style: TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product info
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jagung Kristal Merpati 1 KG - 25 KG',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4 ? Icons.star : Icons.star_half,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${product.rating} | ${product.reviews} Penilaian',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Rp. 15.000,00 - Rp. 230.000,00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Product type
                  Text(
                    'Jenis Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Biji-Bijian',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),

                  // Product weight
                  Text(
                    'Berat Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildWeightOption('25.5 KG', 'Berat Kotor'),
                      SizedBox(width: 20),
                      _buildWeightOption('25 KG', 'Berat Bersih'),
                      SizedBox(width: 20),
                      _buildWeightOption('500 Gr', 'Berat Kemasan'),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Product dimensions
                  Text(
                    'Dimensi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDimensionOption('45 Cm', 'Panjang'),
                      SizedBox(width: 20),
                      _buildDimensionOption('14 Cm', 'Lebar'),
                      SizedBox(width: 20),
                      _buildDimensionOption('75 Cm', 'Tinggi'),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Product description
                  Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 40),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            cartProvider.addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Produk ditambahkan ke keranjang'),
                                backgroundColor: Colors.green[700],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.green[700]!),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Masukkan Keranjang',
                            style: TextStyle(color: Colors.green[700]),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            cartProvider.addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Produk ditambahkan ke keranjang'),
                                backgroundColor: Colors.green[700],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Beli Produk',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
