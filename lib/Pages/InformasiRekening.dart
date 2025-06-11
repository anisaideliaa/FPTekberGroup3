import 'package:flutter/material.dart';

class InformasiRekeningPage extends StatefulWidget {
  const InformasiRekeningPage({super.key});

  @override
  State<InformasiRekeningPage> createState() => _InformasiBankPageState();
}

class _InformasiBankPageState extends State<InformasiRekeningPage> {
  // Data dummy rekening
  String _bankName = 'BNI';
  String _accountNumber = '1234567890';

  // Controllers untuk mode edit
  String? _selectedBank; // Untuk DropdownButton
  final TextEditingController _accountNumberController =
      TextEditingController();

  bool _isEditing = false; // State untuk mengontrol mode baca/edit

  // Daftar bank untuk Dropdown
  final List<String> _bankList = [
    'BNI',
    'BCA',
    'Mandiri',
    'BRI',
    'CIMB Niaga',
    'Permata Bank',
    // Tambahkan bank lain sesuai kebutuhan
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data awal
    _selectedBank = _bankName; // Pastikan bank awal ada di _bankList
    _accountNumberController.text = _accountNumber;
  }

  @override
  void dispose() {
    // Pastikan untuk membuang controller
    _accountNumberController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan dialog konfirmasi pembatalan
  Future<bool> _showCancelConfirmationDialog() async {
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
                                    .pop(false); // Buang (tidak batal)
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
      canPop: true,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (_isEditing) {
          final bool shouldPop = await _showCancelConfirmationDialog();
          if (shouldPop) {
            // Reset controller ke nilai awal sebelum pop
            _selectedBank = _bankName;
            _accountNumberController.text = _accountNumber;

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
              Navigator.of(context).pop(); // Trigger onPopInvoked
            },
          ),
          title: Text(
            _isEditing
                ? 'Update Informasi Rekening'
                : 'Profil Informasi Rekening',
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
              if (_isEditing) ...[
                const Text(
                  'Perbarui Data Rekening Bank Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rekening bank akan digunakan sebagai rekening tujuan pencairan dana usaha Anda',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 30),

                // Pilih Bank (Dropdown)
                _buildBankDropdownField(
                  label: 'Pilih Bank',
                  value: _selectedBank,
                  items: _bankList,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBank = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Nomor Rekening Bank (TextFormField dengan tombol Periksa)
                _buildAccountNumberField(
                  label: 'Nomor Rekening Bank',
                  controller: _accountNumberController,
                  onCheck: () {
                    // Logic untuk memeriksa nomor rekening
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Memeriksa nomor rekening: ${_accountNumberController.text}')),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ] else ...[
                // Tampilan Baca Saja
                _buildInfoRow('Bank', _bankName),
                const SizedBox(height: 20),
                _buildInfoRow('Nomor Rekening Bank', _accountNumber),
                const SizedBox(height: 40),
              ],

              // Tombol Perbarui/Simpan Informasi Rekening
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_isEditing) {
                        // Simpan perubahan dari controller ke variabel state
                        _bankName = _selectedBank ??
                            _bankName; // Gunakan bank yang dipilih
                        _accountNumber = _accountNumberController.text;

                        // Logika simpan data ke backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Informasi rekening berhasil disimpan!')),
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
                        ? 'Simpan Informasi Rekening'
                        : 'Perbarui Informasi Rekening',
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

  // Widget untuk DropdownButtonFormField untuk pemilihan bank
  Widget _buildBankDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
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
          dropdownColor: Colors.white, // Warna latar belakang dropdown
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Widget untuk Nomor Rekening Bank dengan tombol "Periksa"
  Widget _buildAccountNumberField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onCheck,
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
          keyboardType: TextInputType.number, // Hanya angka
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            hintText: 'Nomor Rekening Bank',
            hintStyle:
                const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            filled: true,
            fillColor: Colors.white,
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
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: onCheck,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D844A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size.zero, // Hapus padding default tombol
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text(
                  'Periksa',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
                minWidth: 0, minHeight: 0), // Menghilangkan batasan lebar ikon
          ),
        ),
      ],
    );
  }
}
