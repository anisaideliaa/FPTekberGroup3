import 'package:flutter/material.dart';

class InformasiTokoPage extends StatefulWidget {
  const InformasiTokoPage({super.key});

  @override
  State<InformasiTokoPage> createState() => _InformasiTokoPageState();
}

class _InformasiTokoPageState extends State<InformasiTokoPage> {
  // Data dummy toko
  String _namaToko = 'CV. Maju Jaya Hasil Tani, Blok M';
  String _lokasiMapText = 'Jalan Raya Jaksa | RT.06/RW.03 Keputih, Sukolilo';
  String _patokan = 'Depan Masjid Al-Muttaqin';
  String _kodePos = '60111';
  String _kota = 'Surabaya';
  String _jasaPengiriman = 'Mobil Box'; // Data default untuk mode baca
  String _ukuranAngkutPanjang = '315 Cm';
  String _ukuranAngkutLebar = '215 Cm';
  String _ukuranAngkutTinggi = '235 Cm';
  String _nomorTeleponToko = '081234567890';
  String _emailToko = 'mjhasilani@gmail.com';
  String _besaranPajakPKP = '12%';

  // Controllers untuk mode edit
  final TextEditingController _namaTokoController = TextEditingController();
  final TextEditingController _patokanController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _nomorTeleponTokoController =
      TextEditingController();
  final TextEditingController _emailTokoController = TextEditingController();
  final TextEditingController _besaranPajakPKPController =
      TextEditingController();

  // Variables for dropdowns and checkboxes
  String? _selectedJasaPengiriman;
  String? _selectedUkuranAngkutPanjang;
  String? _selectedUkuranAngkutLebar;
  String? _selectedUkuranAngkutTinggi;
  bool _menyediakanJasaPengiriman = true; // Default sesuai gambar
  bool _samakanNoTelpPendaftaran = false;
  bool _samakanEmailPendaftaran = false;
  bool _apakahTermasukPKP = true; // Default sesuai gambar

  bool _isEditing = false; // State untuk mengontrol mode baca/edit

  // Dummy lists for dropdowns
  final List<String> _jasaPengirimanOptions = [
    'Mobil Box',
    'Pick-up',
    'Truk Kecil',
    'Motor'
  ];
  final List<String> _ukuranAngkutOptions = [
    '100 Cm',
    '150 Cm',
    '200 Cm',
    '250 Cm',
    '300 Cm',
    '315 Cm'
  ];
  final List<String> _persenPKPOptions = ['0%', '5%', '10%', '12%', '15%'];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data awal
    _namaTokoController.text = _namaToko;
    _patokanController.text = _patokan;
    _kodePosController.text = _kodePos;
    _kotaController.text = _kota;
    _nomorTeleponTokoController.text = _nomorTeleponToko;
    _emailTokoController.text = _emailToko;
    _besaranPajakPKPController.text = _besaranPajakPKP;

    // Inisialisasi nilai dropdown awal
    _selectedJasaPengiriman = _jasaPengiriman;
    _selectedUkuranAngkutPanjang = _ukuranAngkutPanjang;
    _selectedUkuranAngkutLebar = _ukuranAngkutLebar;
    _selectedUkuranAngkutTinggi = _ukuranAngkutTinggi;
  }

  @override
  void dispose() {
    // Pastikan untuk membuang controller
    _namaTokoController.dispose();
    _patokanController.dispose();
    _kodePosController.dispose();
    _kotaController.dispose();
    _nomorTeleponTokoController.dispose();
    _emailTokoController.dispose();
    _besaranPajakPKPController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan dialog konfirmasi pembatalan
  Future<bool> _showCancelConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.of(dialogContext).size.width * 0.8,
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
                                backgroundColor: Colors.red.shade400,
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
                                backgroundColor: const Color(0xFF5D844A),
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
            // Reset controller dan state ke nilai awal sebelum pop
            _namaTokoController.text = _namaToko;
            _patokanController.text = _patokan;
            _kodePosController.text = _kodePos;
            _kotaController.text = _kota;
            _nomorTeleponTokoController.text = _nomorTeleponToko;
            _emailTokoController.text = _emailToko;
            _besaranPajakPKPController.text = _besaranPajakPKP;
            _selectedJasaPengiriman = _jasaPengiriman;
            _selectedUkuranAngkutPanjang = _ukuranAngkutPanjang;
            _selectedUkuranAngkutLebar = _ukuranAngkutLebar;
            _selectedUkuranAngkutTinggi = _ukuranAngkutTinggi;
            _menyediakanJasaPengiriman = true; // Atau nilai default yang sesuai
            _samakanNoTelpPendaftaran = false;
            _samakanEmailPendaftaran = false;
            _apakahTermasukPKP = true; // Atau nilai default yang sesuai

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
            _isEditing ? 'Update Informasi Toko' : 'Profil Informasi Toko',
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
              if (!_isEditing) ...[
                // Tampilan Baca Saja
                _buildInfoRow('Nama Toko', _namaToko),
                const SizedBox(height: 20),
                _buildMapSection(
                  label: 'Lokasi Toko',
                  locationText: _lokasiMapText,
                  isEditing: false,
                ),
                const SizedBox(height: 20),
                _buildInfoRow('Patokan', _patokan),
                const SizedBox(height: 20),
                _buildInfoRow('Kode Pos', _kodePos),
                const SizedBox(height: 20),
                _buildInfoRow('Kota', _kota),
                const SizedBox(height: 20),
                _buildInfoRow('Jasa Pengiriman', _jasaPengiriman),
                const SizedBox(height: 20),
                _buildUkuranAngkutRow(
                  _ukuranAngkutPanjang,
                  _ukuranAngkutLebar,
                  _ukuranAngkutTinggi,
                ),
                const SizedBox(height: 20),
                _buildPhotoUploadSection(
                    label: 'Foto Kendaraan',
                    photoText: 'Foto Kendaraan Tampak Depan dan belakang',
                    onUpload: () {}),
                const SizedBox(height: 20),
                _buildInfoRow('Nomor Telepon Toko', _nomorTeleponToko),
                const SizedBox(height: 20),
                _buildInfoRow('Email Toko', _emailToko),
                const SizedBox(height: 20),
                _buildInfoRow('Besaran Pajak PKP', _besaranPajakPKP),
                const SizedBox(height: 40),
              ] else ...[
                // Tampilan Edit
                _buildEditableTextField(
                  label: 'Nama Toko',
                  controller: _namaTokoController,
                  hintText: 'Cnth: CV. Maju Jaya Hasil Tani',
                  bottomNote:
                      'Nama Toko harus ditulis sesuai dengan nama tepat, lihat panduan untuk pengisian nama yang tepat',
                  suffixWidget: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Buka Panduan Nama Toko')),
                      );
                    },
                    child: const Text(
                      'Panduan',
                      style: TextStyle(
                        color: Color(0xFF5D844A),
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildMapSection(
                  label: 'Lokasi Toko',
                  locationText: _lokasiMapText,
                  isEditing: true,
                  onUpdateLocation: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ubah Lokasi di Peta')),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildEditableTextField(
                  label: 'Patokan (opsional)',
                  controller: _patokanController,
                  hintText: 'Cnth: Depan Masjid Al-Muttaqin',
                ),
                const SizedBox(height: 20),
                _buildEditableTextField(
                  label: 'Kode Pos',
                  controller: _kodePosController,
                  hintText: 'Cnth: 60111',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildEditableTextField(
                  label: 'Kota',
                  controller: _kotaController,
                  hintText: 'Kota',
                ),
                const SizedBox(height: 20),

                // Apakah Menyediakan Jasa Pengiriman?
                _buildCheckboxRow(
                  label: 'Apakah Menyediakan Jasa Pengiriman?',
                  value: _menyediakanJasaPengiriman,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _menyediakanJasaPengiriman = newValue ?? false;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Jasa Pengiriman (Dropdown)
                if (_menyediakanJasaPengiriman) // Hanya tampil jika menyediakan jasa pengiriman
                  _buildDropdownField(
                    label: 'Jasa Pengiriman',
                    value: _selectedJasaPengiriman,
                    items: _jasaPengirimanOptions,
                    hintText: 'Pilih Jasa Pengiriman',
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedJasaPengiriman = newValue;
                      });
                    },
                  ),
                const SizedBox(height: 20),

                // Ukuran Angkut (Dropdowns)
                const Text(
                  'Ukuran Angkut',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Panjang Cm',
                        value: _selectedUkuranAngkutPanjang,
                        items: _ukuranAngkutOptions,
                        hintText: 'Panjang Cm',
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUkuranAngkutPanjang = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Lebar Cm',
                        value: _selectedUkuranAngkutLebar,
                        items: _ukuranAngkutOptions,
                        hintText: 'Lebar Cm',
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUkuranAngkutLebar = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Tinggi Cm',
                        value: _selectedUkuranAngkutTinggi,
                        items: _ukuranAngkutOptions,
                        hintText: 'Tinggi Cm',
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUkuranAngkutTinggi = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildPhotoUploadSection(
                  label: 'Foto Kendaraan',
                  photoText: 'Foto Kendaraan Tampak Depan dan belakang',
                  onUpload: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upload Foto Kendaraan')),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Nomor Telepon Toko
                _buildEditableTextField(
                  label: 'Nomor Telepon Toko',
                  controller: _nomorTeleponTokoController,
                  hintText: 'Nomor Telepon Toko',
                  keyboardType: TextInputType.phone,
                  topNote: 'Nomor Telepon yang dapat dihubungi oleh pelanggan',
                ),
                _buildCheckboxRow(
                  label:
                      'Samakan Nomor Telepon Toko dengan Nomor Telepon Pendaftaran',
                  value: _samakanNoTelpPendaftaran,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _samakanNoTelpPendaftaran = newValue ?? false;
                      // Logic untuk menyamakan dengan nomor pendaftaran
                      if (_samakanNoTelpPendaftaran) {
                        _nomorTeleponTokoController.text =
                            '081234567890'; // Dummy nomor pendaftaran
                      }
                    });
                  },
                  leftPadding: 0, // Hapus padding default untuk checkbox ini
                ),
                const SizedBox(height: 20),

                // Email Toko
                _buildEditableTextField(
                  label: 'Email Toko',
                  controller: _emailTokoController,
                  hintText: 'mjhasilani@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  topNote: 'Email yang dapat dihubungi oleh pelanggan',
                ),
                _buildCheckboxRow(
                  label: 'Samakan Email Toko dengan Email Pendaftaran',
                  value: _samakanEmailPendaftaran,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _samakanEmailPendaftaran = newValue ?? false;
                      // Logic untuk menyamakan dengan email pendaftaran
                      if (_samakanEmailPendaftaran) {
                        _emailTokoController.text =
                            'emailterdaftar@example.com'; // Dummy email pendaftaran
                      }
                    });
                  },
                  leftPadding: 0, // Hapus padding default untuk checkbox ini
                ),
                const SizedBox(height: 20),

                // Apakah Termasuk PKP (opsional)
                _buildEditableTextField(
                  label: 'Besaran Pajak PKP (opsional)',
                  controller: _besaranPajakPKPController,
                  hintText: 'Max 12%',
                  keyboardType: TextInputType
                      .number, // Atau TextInputType.text jika ada '%'
                  suffixWidget: DropdownButtonHideUnderline(
                    // Menyembunyikan garis bawah dropdown
                    child: DropdownButton<String>(
                      value: _besaranPajakPKPController
                          .text, // Mengambil nilai dari controller
                      icon:
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _besaranPajakPKPController.text = newValue!;
                        });
                      },
                      items: _persenPKPOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],

              // Tombol Perbarui/Simpan Informasi Toko
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_isEditing) {
                        // Simpan perubahan dari controller ke variabel state
                        _namaToko = _namaTokoController.text;
                        _patokan = _patokanController.text;
                        _kodePos = _kodePosController.text;
                        _kota = _kotaController.text;
                        _jasaPengiriman =
                            _selectedJasaPengiriman ?? _jasaPengiriman;
                        _ukuranAngkutPanjang = _selectedUkuranAngkutPanjang ??
                            _ukuranAngkutPanjang;
                        _ukuranAngkutLebar =
                            _selectedUkuranAngkutLebar ?? _ukuranAngkutLebar;
                        _ukuranAngkutTinggi =
                            _selectedUkuranAngkutTinggi ?? _ukuranAngkutTinggi;
                        _nomorTeleponToko = _nomorTeleponTokoController.text;
                        _emailToko = _emailTokoController.text;
                        _besaranPajakPKP = _besaranPajakPKPController.text;
                        // _menyediakanJasaPengiriman, _samakanNoTelpPendaftaran, _samakanEmailPendaftaran, _apakahTermasukPKP sudah diupdate via onChanged

                        // Logika simpan data ke backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Informasi toko berhasil disimpan!')),
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
                        ? 'Simpan Informasi Toko'
                        : 'Perbarui Informasi Toko',
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

  // Widget untuk bagian peta
  Widget _buildMapSection({
    required String label,
    required String locationText,
    required bool isEditing,
    VoidCallback? onUpdateLocation,
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
        const SizedBox(height: 8),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Stack(
            children: [
              // Placeholder gambar peta
              Center(
                child: Image.asset(
                  'assets/images/map_placeholder.jpg', // Ganti dengan path gambar peta Anda
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              if (isEditing)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: onUpdateLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D844A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Ubah',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          locationText,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  // Widget untuk ukuran angkut di mode baca
  Widget _buildUkuranAngkutRow(String panjang, String lebar, String tinggi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ukuran Angkut',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              panjang,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              lebar,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              tinggi,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget untuk bagian upload foto kendaraan
  Widget _buildPhotoUploadSection(
      {required String label,
      required String photoText,
      required VoidCallback onUpload}) {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.image_outlined,
                        size: 50, color: Colors.grey),
                    Text(
                      photoText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        fontSize: 12,
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
    String? bottomNote, // Catatan di bawah form
    String? topNote, // Catatan di atas form
    Widget? suffixWidget, // Widget opsional di akhir (misal: tombol Panduan)
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
        if (topNote != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              topNote,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Poppins',
              ),
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
            suffixIcon: suffixWidget != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: suffixWidget,
                  )
                : null,
            suffixIconConstraints: suffixWidget != null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null,
          ),
        ),
        if (bottomNote != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 5.0),
            child: Text(
              bottomNote,
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

  // Widget untuk Checkbox dan teks
  Widget _buildCheckboxRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    double leftPadding = 0, // Untuk mengatur indentasi
  }) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding), // Contoh indentasi
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF5D844A),
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk DropdownField umum
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hintText,
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
          hint: hintText != null
              ? Text(
                  hintText,
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: 'Poppins'),
                )
              : null,
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
          dropdownColor: Colors.white,
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
}
