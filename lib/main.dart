import 'package:flutter/material.dart';
import 'package:pasar_tani_nelayan/Pages/HomeToko.dart';
import 'package:pasar_tani_nelayan/Pages/TambahProduk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        // Tambahkan warna primer dan aksen untuk tampilan yang lebih menarik
        primarySwatch: Colors.green,
        // Atur warna teks default agar mudah dibaca
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TokoHomePage(),
        '/tambah_produk': (context) => const TambahProduk(),
      },
    );
  }
}