import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import 'PembayaranPage.dart';
import 'PilihLokasiPage.dart';
import 'package:latlong2/latlong.dart';

class CheckoutPage extends StatefulWidget {
  final CartProvider cartProvider;

  const CheckoutPage({Key? key, required this.cartProvider}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool gunakanKupon = false;
  String selectedAddress = 'Belum dipilih';

  @override
  Widget build(BuildContext context) {
    final shippingFee = 20000;
    final shippingDiscount = gunakanKupon ? shippingFee : 0;

    final productTotal = widget.cartProvider.totalPrice;
    final totalPrice = productTotal + shippingFee - shippingDiscount;

    final cartItems = widget.cartProvider.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3E7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Alamat Anda',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(selectedAddress,
                        style: const TextStyle(fontSize: 15))),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () async {
                    final result = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PilihLokasiPage(),
                      ),
                    );
                    if (result != null && result.isNotEmpty) {
                      setState(() {
                        selectedAddress = result;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...cartItems.map((item) => _buildCartItem(item)).toList(),
            const SizedBox(height: 24),
            _sectionTitle('Metode Pengiriman'),
            const Text('Pengiriman Reguler\n1-2 Hari',
                style: TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            _sectionTitle('Metode Pembayaran'),
            const Text('Bank BNI\n120*****54', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            const Text('Kupon Harga',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<bool>(
              value: gunakanKupon,
              items: const [
                DropdownMenuItem(
                    value: false, child: Text('Tidak Menggunakan Kupon')),
                DropdownMenuItem(
                    value: true, child: Text('Gratis Ongkir Daerah Surabaya')),
              ],
              onChanged: (value) {
                setState(() {
                  gunakanKupon = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Total Harga',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _priceRow('Harga Produk',
                      '+Rp. ${productTotal.toStringAsFixed(0)}'),
                  _priceRow('Biaya Pengiriman', '+Rp. $shippingFee'),
                  _priceRow('Potongan Ongkir', '-Rp. $shippingDiscount'),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Harga',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        'Rp. ${totalPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green[900]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PembayaranPage(
                          cartProvider: widget.cartProvider,
                          totalHarga: totalPrice,
                        ),
                      ),
                    );
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

  Widget _buildCartItem(cartItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFB6BC8A),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: cartItem.product.image.startsWith('http')
                ? Image.network(cartItem.product.image, fit: BoxFit.cover)
                : Center(
                    child: Text(cartItem.product.image,
                        style: const TextStyle(fontSize: 36)),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cartItem.product.seller,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 4),
                Text(cartItem.product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (cartItem.quantity > 1) {
                            cartItem.quantity--;
                          } else {
                            widget.cartProvider.removeItem(cartItem.product.id);
                          }
                        });
                      },
                    ),
                    Text('${cartItem.quantity}',
                        style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          cartItem.quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
        ],
      );

  Widget _priceRow(String label, String value) => Padding(
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
