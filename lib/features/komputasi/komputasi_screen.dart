import 'package:flutter/material.dart';
import '../../core/date_utils.dart';

class KomputasiScreen extends StatefulWidget {
  const KomputasiScreen({super.key});
  @override
  State<KomputasiScreen> createState() => _KomputasiScreenState();
}

class _KomputasiScreenState extends State<KomputasiScreen> {
  DateTime? _hpht;
  DateTime? _hpl;
  String? _usia;
  String? _trimester;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _hpht ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null) setState(() => _hpht = picked);
  }

  void _hitung() {
    if (_hpht == null) return;
    final now = DateTime.now();
    final hari = now.difference(_hpht!).inDays;
    final hpl = KalenderUtil.naegeleHpl(_hpht!);
    if (hari < 0) {
      setState(() {
        _hpl = hpl;
        _usia = 'HPHT masih di masa depan';
        _trimester = '-';
      });
      return;
    }
    final minggu = hari ~/ 7;
    final sisaHari = hari % 7;
    final tri = minggu < 13
        ? 'Trimester I'
        : (minggu < 27 ? 'Trimester II' : (minggu <= 42 ? 'Trimester III' : 'Di luar rentang kehamilan'));
    setState(() {
      _hpl = hpl;
      _usia = '$minggu minggu $sisaHari hari ($hari hari)';
      _trimester = tri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Komputasi HPL')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(_hpht == null
                  ? 'Pilih Hari Pertama Haid Terakhir'
                  : _hpht!.toIso8601String().split('T').first),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _hpht == null ? null : _hitung, child: const Text('Hitung Perkiraan Lahir')),
            const SizedBox(height: 16),
            if (_hpl != null)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimasi lahir (HPL): ${_hpl!.toIso8601String().split('T').first}'),
                      Text('Usia kehamilan: $_usia'),
                      Text('Trimester: $_trimester'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'Rumus Naegele: HPHT + 7 hari - 3 bulan + 1 tahun. Hanya valid '
              'untuk siklus haid teratur 28 hari - sebutkan asumsi ini di laporan.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
