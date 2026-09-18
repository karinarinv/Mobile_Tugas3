import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../core/auth_provider.dart';
import '../auth/login_screen.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instructions = [
      'Login memakai akun bidan yang terdaftar.',
      'Menu Komputasi HPL menghitung perkiraan hari lahir dari HPHT.',
      'Menu Data Pasien membantu mengelola data pasien klinik.',
      'Menu Konversi Umur menghitung usia sampai satuan detik.',
      'Menu Kalender mengonversi tanggal ke Hijriah, weton, dan Saka Bali.',
      'Tab Stopwatch mengukur durasi kontraksi.',
    ];

    return Scaffold(
      backgroundColor: KlinikBidanPalette.background,
      appBar: AppBar(
        title: const Text('Pusat Bantuan & Akun'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: KlinikBidanPalette.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: KlinikBidanPalette.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: KlinikBidanPalette.lightGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.support_agent_rounded, color: KlinikBidanPalette.darkGreen),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Cara Penggunaan Aplikasi',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: KlinikBidanPalette.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...instructions.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: KlinikBidanPalette.lightPink,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: KlinikBidanPalette.textPrimary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  color: KlinikBidanPalette.textPrimary,
                                  height: 1.5,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF9D9DF),
                  foregroundColor: KlinikBidanPalette.darkGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar (Logout)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
