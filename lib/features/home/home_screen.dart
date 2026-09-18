import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api_client.dart';
import '../../core/app_theme.dart';
import '../../core/auth_provider.dart';
import '../../models/pasien.dart';
import '../anggota/anggota_screen.dart';
import '../komputasi/komputasi_screen.dart';
import '../crud/pasien_list_screen.dart';
import '../umur/umur_screen.dart';
import '../kalender/kalender_screen.dart';

class _MenuItem {
  final String title, subtitle;
  final IconData icon;
  final Widget page;
  _MenuItem(this.title, this.subtitle, this.icon, this.page);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final token = auth.token ?? '';
    final pasienFuture = token.isEmpty
        ? Future.value(<Pasien>[])
        : ApiClient.getPasienList(token);

    final menus = [
      _MenuItem('Daftar Anggota Kelompok', 'Profil dan pembagian tugas tim', Icons.groups_rounded, const AnggotaScreen()),
      _MenuItem('Komputasi HPL', 'Hitung perkiraan lahir & usia kehamilan', Icons.calculate_rounded, const KomputasiScreen()),
      _MenuItem('Data Pasien', 'Tambah, ubah, hapus data pasien', Icons.folder_shared_rounded, const PasienListScreen()),
      _MenuItem('Konversi Umur Detail', 'Tahun, bulan, hari, jam, menit, detik', Icons.hourglass_bottom_rounded, const UmurScreen()),
      _MenuItem('Kalender Weton & Hijriah', 'Konversi Jawa, Bali & Islam', Icons.calendar_month_rounded, const KalenderScreen()),
    ];

    return Scaffold(
      backgroundColor: KlinikBidanPalette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [KlinikBidanPalette.lightPink, KlinikBidanPalette.lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: KlinikBidanPalette.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.local_hospital_rounded, color: KlinikBidanPalette.darkGreen),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: KlinikBidanPalette.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Aktif',
                            style: TextStyle(
                              color: KlinikBidanPalette.darkGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Selamat datang,',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KlinikBidanPalette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bidan Asti, S.Tr.Keb',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: KlinikBidanPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    FutureBuilder<List<Pasien>>(
                      future: pasienFuture,
                      builder: (context, snapshot) {
                        final count = snapshot.connectionState == ConnectionState.waiting
                            ? 0
                            : (snapshot.data?.length ?? 0);
                        return Row(
                          children: [
                            _StatChip(label: 'Pasien', value: '$count'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Menu utama',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: KlinikBidanPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menus.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _MenuTile(item: menus[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: KlinikBidanPalette.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: KlinikBidanPalette.textSecondary, fontSize: 10),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: KlinikBidanPalette.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.page)),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: KlinikBidanPalette.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: KlinikBidanPalette.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: KlinikBidanPalette.lightGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item.icon, color: KlinikBidanPalette.darkGreen),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: KlinikBidanPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: KlinikBidanPalette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: KlinikBidanPalette.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
