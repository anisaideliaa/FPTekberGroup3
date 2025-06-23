import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // HARUS ADA, dari flutterfire configure

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
import 'package:pasar_tani_nelayan/Pages/ProfilUsaha.dart';
import 'package:pasar_tani_nelayan/Pages/KelolaPesananPage.dart';

import 'package:pasar_tani_nelayan/Pages/IdentitasPemilikPage.dart';
import 'package:pasar_tani_nelayan/Pages/InformasiAkunUsaha.dart';
import 'package:pasar_tani_nelayan/Pages/InformasiToko.dart';
import 'package:pasar_tani_nelayan/Pages/LoginPage.dart';
import 'package:pasar_tani_nelayan/Pages/RegisterPage.dart';
import 'package:pasar_tani_nelayan/Pages/Homepage.dart';
import 'package:pasar_tani_nelayan/Pages/InformasiRekening.dart';
import 'package:pasar_tani_nelayan/Pages/LoginPageToko.dart'; // <<< IMPORT BARU

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF9F7E8),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Poppins',
          ),
          iconTheme: IconThemeData(color: Color(0xFF5D844A)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        'homepage': (context) => HomePage(),
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
        '/profil_usaha': (context) => const ProfileUsaha(),
        '/informasi_usaha': (context) => const InformasiAkunUsahaPage(),
        '/identitas_pemilik': (context) => const IdentitasPemilikPage(),
        '/informasi_rekening': (context) => const InformasiRekeningPage(),
        '/informasi_toko': (context) => const InformasiTokoPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/toko_homepage': (context) => const TokoHomePage(),
        '/kelola_pesanan': (context) => const KelolaPesananPage(),
        '/login_page_toko': (context) => const LoginPageToko(),
      },
    );
  }
}
