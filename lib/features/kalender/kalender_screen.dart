import 'package:flutter/material.dart';
import '../../core/date_utils.dart';

class KalenderScreen extends StatefulWidget {
  const KalenderScreen({super.key});
  @override
  State<KalenderScreen> createState() => _KalenderScreenState();
}

class _KalenderScreenState extends State<KalenderScreen> {
  DateTime _tanggal = DateTime.now();
  WetonResult? _weton;
  String? _hijri;
  int? _saka;
  String? _wuku;

  Future<void> _pick() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(1000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  void _konversi() {
    setState(() {
      _weton = KalenderUtil.weton(_tanggal);
      _hijri = KalenderUtil.hijriLabel(_tanggal);
      _saka = KalenderUtil.sakaYear(_tanggal);
      _wuku = KalenderUtil.wuku(_tanggal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weton, Saka & Hijriah')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: _pick,
              icon: const Icon(Icons.calendar_month),
              label: Text(_tanggal.toIso8601String().split('T').first),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _konversi, child: const Text('Konversi Kalender')),
            const SizedBox(height: 16),
            if (_weton != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🌙 Hijriah: $_hijri'),
                      Text('🌾 Weton Jawa: ${_weton!.hari} ${_weton!.pasaran}'),
                      Text('🔢 Neptu: ${_weton!.neptu}'),
                      Text('🏛️ Tahun Saka Bali: $_saka Saka  (aproksimasi)'),
                      Text('🌀 Wuku: $_wuku  (perlu kalibrasi)'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'Weton dikalibrasi ke 17 Agustus 1945 = Jumat Legi. Hijriah pakai '
              'algoritma tabular (aritmetika), bisa beda 1 hari dari rukyat. '
              'Tahun Saka & wuku adalah pendekatan - verifikasi ke sumber resmi '
              'sebelum dipakai untuk laporan akhir.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
