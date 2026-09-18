import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
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
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1000),
      lastDate: now,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
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
    final surface = KlinikBidanPalette.background;
    final pinkSoft = KlinikBidanPalette.lightPink;
    final pinkBorder = const Color(0xFFF4C9D6);
    final greenSoft = KlinikBidanPalette.lightGreen;
    final greenDark = KlinikBidanPalette.darkGreen;
    final textPrimary = KlinikBidanPalette.textPrimary;
    final textSecondary = KlinikBidanPalette.textSecondary;
    final white = KlinikBidanPalette.white;

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        title: const Text('Konversi Umur Detail'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Hitung Usia Presisi',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih tanggal dan waktu lahir untuk menghitung usia berdasarkan tahun, bulan, hari, jam, menit, dan detik.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tanggal & Waktu Lahir',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih tanggal dan jam lahir Anda.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pick,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: white,
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.event_available_rounded, color: greenDark, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _lahir == null
                                ? 'Pilih tanggal & jam lahir'
                                : '${_lahir!.day.toString().padLeft(2, '0')} '
                                  '${_monthName(_lahir!.month)} ${_lahir!.year} '
                                  '${_lahir!.hour.toString().padLeft(2, '0')}:${_lahir!.minute.toString().padLeft(2, '0')}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: _lahir == null ? textSecondary : textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _lahir == null ? null : _mulai,
                    style: FilledButton.styleFrom(
                      backgroundColor: greenDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Hitung Umur Presisi',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                if (_umur != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: pinkSoft,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: pinkBorder, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.cake_rounded, color: Color(0xFF356859), size: 20),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Hasil Perhitungan',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '${_umur!.tahun} tahun, ${_umur!.bulan} bulan, ${_umur!.hari} hari',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoBox(
                                label: 'Jam',
                                value: '${_umur!.jam}',
                                accent: white.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InfoBox(
                                label: 'Menit',
                                value: '${_umur!.menit}',
                                accent: greenSoft,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _InfoBox(
                          label: 'Detik',
                          value: '${_umur!.detik}',
                          accent: white.withOpacity(0.75),
                          fullWidth: true,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catatan',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tahun dan bulan dihitung dengan pengurangan bersusun per satuan, bukan membagi total hari. Panjang bulan tidak tetap.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return names[month];
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  final bool fullWidth;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.accent,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: KlinikBidanPalette.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: KlinikBidanPalette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
