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

  String get _formattedHplDate {
    if (_hpl == null) return '-';
    return '${_hpl!.day.toString().padLeft(2, '0')} '
        '${_monthName(_hpl!.month)} ${_hpl!.year}';
  }

  String _monthName(int month) {
    const names = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return names[month];
  }

  @override
  Widget build(BuildContext context) {
    final surface = const Color(0xFFFAFAF8);
    final pinkSoft = const Color(0xFFFCE4EC);
    final pinkBorder = const Color(0xFFF4C9D6);
    final greenSoft = const Color(0xFFE8F3EC);
    final greenDark = const Color(0xFF356859);
    final textPrimary = const Color(0xFF2F3B46);
    final textSecondary = const Color(0xFF667085);
    final bgWhite = Colors.white;

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        title: const Text('Komputasi HPL'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Hitung Perkiraan Hari Lahir',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masukkan tanggal Hari Pertama Haid Terakhir (HPHT) untuk mengetahui perkiraan tanggal persalinan dan usia kehamilan.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tanggal HPHT',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih tanggal hari pertama haid terakhir Anda.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: bgWhite,
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, color: greenDark, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _hpht == null
                                ? 'Pilih tanggal HPHT'
                                : '${_hpht!.day.toString().padLeft(2, '0')} '
                                  '${_monthName(_hpht!.month)} ${_hpht!.year}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: _hpht == null ? textSecondary : textPrimary,
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
                    onPressed: _hpht == null ? null : _hitung,
                    style: FilledButton.styleFrom(
                      backgroundColor: greenDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Hitung Perkiraan Lahir',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                if (_hpl != null)
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
                                color: bgWhite.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.favorite_rounded, size: 20, color: Color(0xFF356859)),
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
                          'Perkiraan Hari Lahir',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formattedHplDate,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: bgWhite.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Usia Kehamilan',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _usia ?? '-',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: greenSoft,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Trimester',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _trimester ?? '-',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: greenDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                        'Perhitungan menggunakan Rumus Naegele, yaitu berdasarkan tanggal HPHT. Hasil merupakan perkiraan dan dapat berbeda dari tanggal persalinan sebenarnya.',
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
}
