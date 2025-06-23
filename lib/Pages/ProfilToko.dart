import 'package:flutter/material.dart';

class ProfilTokoPage extends StatelessWidget {
  const ProfilTokoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5E9),
      appBar: AppBar(
        title: const Text('Profil Usaha'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            'PETER CROUCH',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 5),
          const Text(
            'CV. Maju Jaya Hasil Tani, Blok M',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: 'Informasi Akun',
            routeName: '/informasi_akun',
          ),
          _buildMenuItem(
            context,
            icon: Icons.location_on_outlined,
            title: 'Alamat Pengguna',
            routeName: '/alamat_pengguna',
          ),
          _buildMenuItem(
            context,
            icon: Icons.account_balance,
            title: 'Informasi Bank',
            routeName: '/informasi_bank',
          ),
          _buildMenuItem(
            context,
            icon: Icons.lock_outline,
            title: 'Ganti Kata Sandi',
            routeName: '/ganti_password',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon, required String title, required String routeName}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF5A6543)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }
}
