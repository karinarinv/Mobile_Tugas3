import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
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
    final background = KlinikBidanPalette.background;
    final white = KlinikBidanPalette.white;
    final cardBorder = const Color(0xFFE5E7EB);
    final textPrimary = KlinikBidanPalette.textPrimary;
    final textSecondary = KlinikBidanPalette.textSecondary;
    final greenSoft = KlinikBidanPalette.lightGreen;
    final pinkSoft = KlinikBidanPalette.lightPink;
    final greenDark = KlinikBidanPalette.darkGreen;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Kalender Weton & Hijriah'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Konversi Kalender',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih tanggal untuk melihat hasil konversi Hijriah, Weton Jawa, Neptu, Saka Bali, dan Wuku.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _pick,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: cardBorder, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: greenSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.calendar_month_rounded, color: greenDark, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _tanggal.toIso8601String().split('T').first,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down_rounded, color: textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _konversi,
                style: FilledButton.styleFrom(
                  backgroundColor: greenDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Konversi Kalender',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),
              if (_weton != null) ...[
                _ResultCard(
                  title: 'Hijriah',
                  icon: Icons.dark_mode_rounded,
                  accent: pinkSoft,
                  value: _hijri ?? '-',
                  subtitle: 'Kalender Islam',
                ),
                const SizedBox(height: 14),
                _ResultCard(
                  title: 'Weton Jawa',
                  icon: Icons.eco_rounded,
                  accent: greenSoft,
                  value: '${_weton!.hari} ${_weton!.pasaran}',
                  subtitle: 'Hari & pasaran',
                ),
                const SizedBox(height: 14),
                _ResultCard(
                  title: 'Neptu',
                  icon: Icons.numbers_rounded,
                  accent: const Color(0xFFEDE7F6),
                  value: '${_weton!.neptu}',
                  subtitle: 'Jumlah nilai weton',
                ),
                const SizedBox(height: 14),
                _ResultCard(
                  title: 'Tahun Saka Bali',
                  icon: Icons.account_balance_rounded,
                  accent: const Color(0xFFE3F2FD),
                  value: '$_saka Saka',
                  subtitle: 'Aproksimasi',
                ),
                const SizedBox(height: 14),
                _ResultCard(
                  title: 'Wuku',
                  icon: Icons.sync_rounded,
                  accent: const Color(0xFFFDE7E7),
                  value: _wuku ?? '-',
                  subtitle: 'Pewukuan tradisional',
                ),
              ],
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: Text(
                  'Weton dikalibrasi ke 17 Agustus 1945 = Jumat Legi. Hijriah memakai algoritma tabular (aritmetika), bisa beda 1 hari dari rukyat. Tahun Saka & wuku adalah pendekatan sebelum dipakai untuk laporan akhir.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final String value;
  final String subtitle;

  const _ResultCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KlinikBidanPalette.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: KlinikBidanPalette.darkGreen, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: KlinikBidanPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: KlinikBidanPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: KlinikBidanPalette.textSecondary,
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
