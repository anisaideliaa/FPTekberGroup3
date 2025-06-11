import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

class CheckoutPage extends StatelessWidget {
  final CartProvider cartProvider;

  const CheckoutPage({Key? key, required this.cartProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for address, shipping, payment, etc.
    final address =
        'Jalan Raya Jaksa | RT.06/RW.03 Keputih, Sukolilo, Surabaya, 60111. (Depan Masjid Al-Muttaqin)';
    final shippingMethod = 'Pengiriman Reguler\n1-2 Hari';
    final paymentMethod = 'Bank BNI\n120*****54';
    final coupon = 'Gratis Ongkir\nDaerah Surabaya';

    // Example: using the first cart item for display
    final cartItem =
        cartProvider.items.isNotEmpty ? cartProvider.items[0] : null;

    // Dummy price breakdown
    final productPrice = 1100000;
    final shippingFee = 180000;
    final guarantee = 0;
    final shippingDiscount = 180000;
    final totalPrice =
        productPrice + shippingFee + guarantee - shippingDiscount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3E7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ClipOval(
              child: Container(
                width: 40,
                height: 40,
                color: Colors.green[100],
                child: Image.asset(
                  'assets/logo.png', // Replace with your logo asset if available
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.eco, color: Colors.green, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'PASAR TANI',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alamat Anda
            const Text(
              'Alamat Anda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product Card
            if (cartItem != null)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFB6BC8A),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Product image
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: cartItem.product.image.startsWith('http')
                          ? Image.network(cartItem.product.image,
                              fit: BoxFit.cover)
                          : Center(
                              child: Text(
                                cartItem.product.image,
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Product info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CV. Maju Jaya Hasil Tani, Blok M',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cartItem.product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Quantity
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${cartItem.quantity} Unit',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Metode Pengiriman
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Metode Pengiriman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
            Text(
              shippingMethod,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),

            // Metode Pembayaran
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
            Text(
              paymentMethod,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),

            // Kupon Harga
            const Text(
              'Kupon Harga',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              coupon,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),

            // Total Harga
            const Text(
              'Total Harga',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _priceRow('Harga Produk', '+Rp. 1.100.000,00'),
                  _priceRow('Biaya Pengiriman', '+Rp. 180.000,00'),
                  _priceRow('Jaminan Produk', '+Rp. 0,00'),
                  _priceRow('Potongan Ongkos Kirim', '-Rp. 180.000,00'),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Harga',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rp. ${totalPrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (match) => '${match[1]}.').replaceAll('.00', ',00')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green[900],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bayar button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B845E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // Handle payment action
                  },
                  child: const Text(
                    'Bayar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
