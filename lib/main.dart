import 'package:flutter/material.dart';
import 'package:pasar_tani_nelayan/Pages/HomeToko.dart';
import 'package:pasar_tani_nelayan/Pages/TambahProduk.dart';
import 'package:pasar_tani_nelayan/Pages/BusinessProfilePage.dart';
import 'package:pasar_tani_nelayan/Pages/EditProfile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pasar Tani Nelayan',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme:
            const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TokoHomePage(),
        '/tambah_produk': (context) => const TambahProduk(),
        '/profil_usaha': (context) => const BusinessProfilePage(),
        '/edit_profile': (context) => const EditProfilePage(),
      },
    );
  }
}
