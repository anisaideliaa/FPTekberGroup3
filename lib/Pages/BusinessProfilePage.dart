import 'package:flutter/material.dart';

class BusinessProfilePage extends StatelessWidget {
  const BusinessProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Light yellow background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profil Usaha',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings,
                color: Color(0xFF8BC34A)), // Green settings icon
            onPressed: () {
              // TODO: Handle settings icon tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo Section
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  color: Colors
                      .white, // Or a very light grey if the image has a background
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/pasartani_logo.png'), // Replace with your logo path
                    fit: BoxFit.contain,
                  ),
                ),
                // If you don't have the exact logo image, you can use a placeholder or text
                // child: Center(
                //   child: Text(
                //     'PASAR TANI',
                //     style: TextStyle(
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold,
                //       color: Color(0xFF8BC34A),
                //     ),
                //   ),
                // ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'CV. Maju Jaya Hasil Tani, Blok M',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildProfileOption(context, 'Informasi Akun'),
            _buildProfileOption(context, 'Identitas Pemilik'),
            _buildProfileOption(context, 'Informasi Rekening'),
            _buildProfileOption(context, 'Informasi Toko'),
            _buildProfileOption(context, 'Komunitas Tani'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement navigation for each option
            print('Tapped on $title');
            // Example navigation:
            // if (title == 'Informasi Akun') {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => AccountInfoPage()));
            // }
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// To run this code, you'll need to set up a basic Flutter app.
// Here's how you might integrate it into your main.dart:

// import 'package:flutter/material.dart';
// import 'package:your_app_name/business_profile_page.dart'; // Assuming you save the above code in business_profile_page.dart

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pasar Tani App',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: const BusinessProfilePage(),
//     );
//   }
// }
