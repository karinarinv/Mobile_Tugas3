import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/date_utils.dart';

class UmurScreen extends StatefulWidget {
  const UmurScreen({super.key});
  @override
  State<UmurScreen> createState() => _UmurScreenState();
}

class _UmurScreenState extends State<UmurScreen> {
  DateTime? _lahir;
  Timer? _timer;
  AgeBreakdown? _umur;

  Future<void> _pick() async {
    final now = DateTime.now();
    final date = await showDatePicker(context: context, initialDate: now, firstDate: DateTime(1990), lastDate: now);
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(now));
    if (time == null) return;
    setState(() => _lahir = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  void _mulai() {
    if (_lahir == null) return;
    _timer?.cancel();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_lahir == null || !mounted) return;
    setState(() => _umur = KalenderUtil.ageBreakdown(_lahir!, DateTime.now()));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Umur Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: _pick,
              icon: const Icon(Icons.event),
              label: Text(_lahir == null ? 'Pilih tanggal & jam lahir' : _lahir.toString()),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _lahir == null ? null : _mulai, child: const Text('Hitung Umur Presisi')),
            const SizedBox(height: 16),
            if (_umur != null)
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${_umur!.tahun} tahun, ${_umur!.bulan} bulan, ${_umur!.hari} hari,\n'
                    '${_umur!.jam} jam, ${_umur!.menit} menit, ${_umur!.detik} detik',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'Tahun dan bulan dihitung dengan pengurangan bersusun per satuan, '
              'bukan membagi total hari - panjang bulan tidak tetap.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
