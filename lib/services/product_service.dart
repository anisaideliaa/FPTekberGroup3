import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final CollectionReference _produkRef =
      FirebaseFirestore.instance.collection('produk');

  Stream<QuerySnapshot> ambilSemuaProduk() {
    return _produkRef.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> tambahProduk(Map<String, dynamic> data) async {
    await _produkRef.add(data);
  }

  Future<void> updateProduk(String id, Map<String, dynamic> data) async {
    await _produkRef.doc(id).update(data);
  }

  Future<void> hapusProduk(String id) async {
    await _produkRef.doc(id).delete();
  }
}
