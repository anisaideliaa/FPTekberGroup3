import 'package:flutter/material.dart';
import 'package:pasar_tani_nelayan/Pages/HomeToko.dart';
import 'package:pasar_tani_nelayan/Pages/TambahProduk.dart';
import 'package:pasar_tani_nelayan/Pages/BusinessProfilePage.dart'; // Pastikan path ini benar dan file ada

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Menghilangkan banner "DEBUG" di pojok kanan atas
      title:
          'Pasar Tani Nelayan', // Judul aplikasi untuk sistem operasi (task switcher)

      theme: ThemeData(
        // Tema utama aplikasi Anda
        fontFamily:
            'Poppins', // Pastikan font 'Poppins' ditambahkan di pubspec.yaml jika ingin digunakan
        primarySwatch: Colors.green, // Palet warna utama aplikasi (hijau)
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Menyesuaikan kepadatan visual berdasarkan platform

        // Pengaturan Text Theme secara global
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black87), // Default text color for larger body text
          bodyMedium: TextStyle(
              color:
                  Colors.black87), // Default text color for general body text
          displayLarge: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
          headlineLarge: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black87),
          titleSmall: TextStyle(color: Colors.black87),
          labelLarge: TextStyle(color: Colors.black),
          labelMedium: TextStyle(color: Colors.black87),
          labelSmall: TextStyle(color: Colors.black87),
        ),

        // Pengaturan AppBar Theme secara global
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Warna latar belakang AppBar
          foregroundColor: Colors.black, // Warna ikon dan teks di AppBar
          elevation: 1, // Ketinggian shadow AppBar
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins', // Font untuk judul AppBar
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      initialRoute: '/', // Rute awal saat aplikasi pertama kali dijalankan
      routes: {
        '/': (context) => const TokoHomePage(), // Rute untuk halaman utama toko
        '/tambah_produk': (context) =>
            const TambahProduk(), // Rute untuk halaman tambah produk
        '/profil_usaha': (context) =>
            const BusinessProfilePage(), // Rute untuk halaman profil usaha Anda
      },
    );
  }
}
