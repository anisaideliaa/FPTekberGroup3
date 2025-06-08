import 'package:flutter/material.dart';
import 'package:pasar_tani_nelayan/Pages/HomeToko.dart';
import 'package:pasar_tani_nelayan/Pages/TambahProduk.dart';
import 'package:pasar_tani_nelayan/Pages/BusinessProfilePage.dart';
import 'package:pasar_tani_nelayan/Pages/EditProfile.dart';
import 'package:pasar_tani_nelayan/Pages/ProfilUser.dart';
import 'package:pasar_tani_nelayan/Pages/RiwayatPesanan.dart';
import 'package:pasar_tani_nelayan/Pages/InformasiAkun.dart';
import 'package:pasar_tani_nelayan/Pages/AlamatPengguna.dart';
import 'package:pasar_tani_nelayan/Pages/InformasiBank.dart';
import 'package:pasar_tani_nelayan/Pages/GantiPassword.dart';
import 'package:pasar_tani_nelayan/Pages/EditProfilUser.dart';
import 'package:pasar_tani_nelayan/Pages/ScreenProfileUsaha.dart';
import 'package:pasar_tani_nelayan/Pages/InformasiAkunUsaha.dart';

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
        '/navigasi_profil_user': (context) => const BusinessProfilePage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/profil_user': (context) => const ProfilUserPage(),
        '/riwayat_pesanan': (context) => const RiwayatPesananPage(),
        '/informasi_akun': (context) => const InformasiAkunPage(),
        '/alamat_pengguna': (context) => const AlamatPenggunaPage(),
        '/informasi_bank': (context) => const InformasiBankPage(),
        '/ganti_password': (context) => const GantiPasswordPage(),
        '/edit_profil_user': (context) => const EditProfilUserPage(),
        '/navigasi_profile_usaha': (context) => const ScreenProfileUsaha(),
        '/profil_usaha': (context) => const InformasiAkunUsahaPage(),
      },
    );
  }
}
