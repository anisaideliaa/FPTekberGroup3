import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PilihLokasiPage extends StatefulWidget {
  final LatLng? initialPosition;

  const PilihLokasiPage({Key? key, this.initialPosition}) : super(key: key);

  @override
  State<PilihLokasiPage> createState() => _PilihLokasiPageState();
}

class _PilihLokasiPageState extends State<PilihLokasiPage> {
  late LatLng _selectedPosition;
  String _address = 'Klik lokasi di peta';

  @override
  void initState() {
    super.initState();
    _selectedPosition =
        widget.initialPosition ?? LatLng(-7.2575, 112.7521); // Surabaya
    // Panggil _updateAddress untuk mendapatkan alamat awal jika initialPosition diberikan
    if (widget.initialPosition != null) {
      _updateAddress(_selectedPosition);
    }
  }

  Future<void> _updateAddress(LatLng position) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}');
    try {
      final response =
          await http.get(url, headers: {'User-Agent': 'pasar-tani-app'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _address = data['display_name'] ?? 'Alamat tidak ditemukan';
        });
      } else {
        setState(() {
          _address = 'Gagal mengambil alamat (Status: ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Gagal mengambil alamat (Error: $e)';
      });
      print('Error fetching address: $e'); // Log error untuk debugging
    }
  }

  void _onTap(TapPosition tapPosition, LatLng tappedPoint) {
    // Perubahan signature onTap
    setState(() {
      _selectedPosition = tappedPoint;
    });
    _updateAddress(tappedPoint);
  }

  void _kirimAlamat() {
    // Pastikan _address sudah terisi sebelum pop
    if (_address.contains('Klik lokasi di peta') ||
        _address.contains('Gagal mengambil alamat')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Silakan pilih lokasi yang valid di peta terlebih dahulu.')),
      );
      return;
    }
    Navigator.pop(context, _address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _selectedPosition, // <<< Perubahan di sini
                initialZoom: 13.0, // <<< Perubahan di sini
                onTap: _onTap, // <<< Perubahan di sini (menyesuaikan signature)
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.pasar_tani_nelayan',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPosition,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on,
                          color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(_address,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _kirimAlamat,
                  icon: const Icon(Icons.check),
                  label: const Text("Gunakan Alamat Ini"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
