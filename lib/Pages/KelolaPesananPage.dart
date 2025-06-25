import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KelolaPesananPage extends StatelessWidget {
  const KelolaPesananPage({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'Menunggu Konfirmasi':
        return Colors.orange;
      case 'Pesanan Diproses':
        return Colors.blue;
      case 'Sedang Dikirim':
        return Colors.green;
      case 'Pesanan Selesai':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  String _buttonLabel(String status) {
    if (status == 'Menunggu Konfirmasi') return 'Terima Pesanan';
    if (status == 'Pesanan Diproses') return 'Kirim Pesanan';
    return '';
  }

  Widget _buildImage(String imageBase64) {
    if (imageBase64.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(imageBase64,
            width: 60, height: 60, fit: BoxFit.cover),
      );
    } else if (imageBase64.length > 100) {
      try {
        final bytes = base64Decode(imageBase64);
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(bytes, width: 60, height: 60, fit: BoxFit.cover),
        );
      } catch (_) {
        return const Icon(Icons.broken_image, size: 40);
      }
    } else {
      return Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(imageBase64, style: const TextStyle(fontSize: 32)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E7),
      appBar: AppBar(
        title: const Text('CV. Maju Jaya Hasil Tani, Blok M'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pesanan').where('status',
            whereIn: [
              'Menunggu Konfirmasi',
              'Pesanan Diproses',
              'Sedang Dikirim',
              'Pesanan Selesai'
            ]).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada pesanan.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              final status = data['status'];
              final imageBase64 = data['imageBase64'] ?? '🛒';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildImage(imageBase64),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Produk: ${data['produk']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Poppins')),
                                const SizedBox(height: 4),
                                Text('Jumlah: ${data['jumlah']} unit',
                                    style:
                                        const TextStyle(fontFamily: 'Poppins')),
                                Text('Total: Rp ${data['total']}',
                                    style:
                                        const TextStyle(fontFamily: 'Poppins')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(status),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                          if (status == 'Menunggu Konfirmasi' ||
                              status == 'Pesanan Diproses')
                            ElevatedButton(
                              onPressed: () async {
                                String newStatus = '';
                                if (status == 'Menunggu Konfirmasi') {
                                  newStatus = 'Pesanan Diproses';
                                } else if (status == 'Pesanan Diproses') {
                                  newStatus = 'Sedang Dikirim';
                                }

                                if (newStatus.isNotEmpty) {
                                  await FirebaseFirestore.instance
                                      .collection('pesanan')
                                      .doc(docId)
                                      .update({'status': newStatus});

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Status pesanan diubah menjadi "$newStatus"'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: Text(
                                _buttonLabel(status),
                                style: const TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
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
          currentIndex: 1,
          onTap: (index) async {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/toko_homepage');
            } else if (index == 2) {
              await Navigator.pushNamed(context, '/profil_usaha');
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.grid_view), label: 'Produk'),
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                label: 'Kelola Pesanan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profil Usaha'),
          ],
        ),
      ),
    );
  }
}
