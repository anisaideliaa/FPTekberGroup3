import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal, tambahkan intl ke pubspec.yaml

class IdentitasPemilikPage extends StatefulWidget {
  const IdentitasPemilikPage({super.key});

  @override
  State<IdentitasPemilikPage> createState() => _IdentitasPemilikPageState();
}

class _IdentitasPemilikPageState extends State<IdentitasPemilikPage> {
  // Data dummy pemilik
  String _nama = 'Budi Santoso';
  String _nomorKTP = '3535140101040005';
  String _tempatLahir = 'Surabaya';
  DateTime? _tanggalLahir = DateTime(2001, 11, 19);
  String _alamatKTP = 'Jalan Raya Jaksa RT.06/RW.03 Keputih, Sukolilo';

  // Controllers untuk mode edit
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorKTPController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatKTPController = TextEditingController();

  bool _isEditing = false; // State untuk mengontrol mode baca/edit

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data awal
    _namaController.text = _nama;
    _nomorKTPController.text = _nomorKTP;
    _tempatLahirController.text = _tempatLahir;
    _tanggalLahirController.text = _tanggalLahir != null
        ? DateFormat('dd MMMM yyyy').format(_tanggalLahir!)
        : '';
    _alamatKTPController.text = _alamatKTP;
  }

  @override
  void dispose() {
    // Pastikan untuk membuang controller
    _namaController.dispose();
    _nomorKTPController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _alamatKTPController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5D844A), // Warna header date picker
              onPrimary: Colors.white, // Warna teks header
              onSurface: Colors.black, // Warna teks tanggal
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color(0xFF5D844A), // Warna tombol OK/Cancel
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
        _tanggalLahirController.text =
            DateFormat('dd MMMM yyyy').format(picked);
      });
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi pembatalan
  Future<bool> _showCancelConfirmationDialog() async {
    // Menggunakan Navigator.of(context).pop() untuk menutup dialog
    // dan mengembalikan nilai boolean
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // Tidak bisa dismiss dengan tap di luar
          builder: (BuildContext dialogContext) {
            return Align(
              alignment: Alignment.topCenter, // Posisikan di atas
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0), // Jarak dari atas
                child: Material(
                  color: Colors.transparent, // Untuk memungkinkan border radius
                  child: Container(
                    width:
                        MediaQuery.of(dialogContext).size.width * 0.8, // Lebar
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Semua perubahan akan dibuang, apakah Anda ingin membatalkan pembaruan?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(false); // Lanjutkan (tidak batal)
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .red.shade400, // Warna merah untuk buang
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                'Buang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(true); // Lanjutkan (batal)
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF5D844A), // Warna hijau untuk lanjutkan
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                'Lanjutkan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ) ??
        false; // Mengembalikan false jika dialog ditutup tanpa pilihan
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Menggantikan WillPopScope
      canPop: true, // Izinkan pop secara default
      onPopInvoked: (didPop) async {
        if (didPop)
          return; // Jika sudah di-pop oleh sistem, jangan lakukan apa-apa

        if (_isEditing) {
          final bool shouldPop = await _showCancelConfirmationDialog();
          if (shouldPop) {
            // Reset controller ke nilai awal sebelum pop
            _namaController.text = _nama;
            _nomorKTPController.text = _nomorKTP;
            _tempatLahirController.text = _tempatLahir;
            _tanggalLahirController.text = _tanggalLahir != null
                ? DateFormat('dd MMMM yyyy').format(_tanggalLahir!)
                : '';
            _alamatKTPController.text = _alamatKTP;

            setState(() {
              _isEditing = false; // Kembali ke mode baca
            });
            if (mounted) Navigator.of(context).pop(); // Pop halaman
          }
        } else {
          if (mounted) Navigator.of(context).pop(); // Pop halaman
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7E8),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9F7E8),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              // Trigger onPopInvoked saat tombol kembali ditekan
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            _isEditing
                ? 'Update Informasi Pemilik'
                : 'Profil Informasi Pemilik',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Poppins',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Foto KTP Pemilik
              _buildPhotoUploadSection(
                  label: 'Foto KTP Pemilik',
                  onUpload: () {
                    // Logic upload foto KTP
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upload Foto KTP')),
                    );
                  }),
              const SizedBox(height: 20),

              // Bagian Data Diri
              if (!_isEditing) ...[
                // Tampilan Baca Saja
                _buildInfoRow('Nama', _nama),
                const SizedBox(height: 20),
                _buildInfoRow('Nomor KTP', _nomorKTP),
                const SizedBox(height: 20),
                _buildInfoRow('Tempat Lahir', _tempatLahir),
                const SizedBox(height: 20),
                _buildInfoRow(
                  'Tanggal Lahir',
                  _tanggalLahir != null
                      ? DateFormat('dd MMMM yyyy').format(_tanggalLahir!)
                      : 'N/A',
                ),
                const SizedBox(height: 20),
                _buildInfoRow('Alamat Sesuai KTP', _alamatKTP),
                const SizedBox(height: 20),
              ] else ...[
                // Tampilan Edit
                _buildEditableTextField(
                  label: 'Nama',
                  controller: _namaController,
                  hintText: 'Nama lengkap sesuai KTP',
                ),
                const SizedBox(height: 20),
                _buildEditableTextField(
                  label: 'Nomor KTP',
                  controller: _nomorKTPController,
                  hintText: 'Cnth: 3535140104xxxx',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildEditableTextField(
                  label: 'Tempat Lahir',
                  controller: _tempatLahirController,
                  hintText: 'Tempat Lahir',
                ),
                const SizedBox(height: 20),
                _buildDatePickerField(
                  label: 'Tanggal Lahir',
                  controller: _tanggalLahirController,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 20),
                _buildEditableTextField(
                  label: 'Alamat Sesuai KTP',
                  controller: _alamatKTPController,
                  hintText: 'Cnth: Jalan Jaksa | RT.06/RW.03',
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
              ],

              // Bagian Foto Diri Dengan KTP
              _buildPhotoUploadSection(
                  label: 'Foto Diri Dengan KTP',
                  onUpload: () {
                    // Logic upload foto diri dengan KTP
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upload Foto Diri')),
                    );
                  }),
              const SizedBox(height: 40),

              // Tombol Perbarui/Simpan Informasi Pemilik
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_isEditing) {
                        // Simpan perubahan dari controller ke variabel state
                        _nama = _namaController.text;
                        _nomorKTP = _nomorKTPController.text;
                        _tempatLahir = _tempatLahirController.text;
                        // _tanggalLahir sudah diupdate di _selectDate
                        _alamatKTP = _alamatKTPController.text;

                        // Logika simpan data ke backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Informasi pemilik berhasil disimpan!')),
                        );
                      }
                      _isEditing = !_isEditing; // Toggle mode
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D844A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    _isEditing
                        ? 'Simpan Informasi Pemilik'
                        : 'Perbarui Informasi Pemilik',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan baris informasi di mode baca
  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Widget untuk bagian upload foto
  Widget _buildPhotoUploadSection(
      {required String label, required VoidCallback onUpload}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 50, color: Colors.grey),
                    Text(
                      'Foto KTP', // Atau 'Foto Diri Dengan KTP'
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onUpload,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D844A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Upload',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget untuk TextField yang bisa diedit
  Widget _buildEditableTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none, // Hapus border default
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF5D844A), width: 2),
            ),
          ),
        ),
        if (label == 'Nama')
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 5.0),
            child: Text(
              'Nama harus ditulis sama seperti yang tertera pada KTP. Termasuk jika ada jabatan, titik, koma, dll',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
      ],
    );
  }

  // Widget untuk field tanggal lahir dengan date picker
  Widget _buildDatePickerField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          readOnly: true, // Tidak bisa diketik langsung
          onTap: onTap, // Membuka date picker saat ditekan
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            hintText: 'Tanggal Lahir',
            hintStyle:
                const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF5D844A), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
