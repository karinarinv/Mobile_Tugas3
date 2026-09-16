import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth_provider.dart';
import '../auth/login_screen.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pusat Bantuan & Akun')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Cara Penggunaan Aplikasi', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            '1. Login memakai akun bidan yang terdaftar.\n'
            '2. Menu Komputasi HPL menghitung perkiraan hari lahir dari HPHT.\n'
            '3. Menu CRUD Pasien mengelola data pasien klinik.\n'
            '4. Menu Konversi Umur menghitung usia sampai satuan detik.\n'
            '5. Menu Kalender mengonversi tanggal ke Hijriah, weton, dan Saka Bali.\n'
            '6. Tab Stopwatch mengukur durasi kontraksi.',
            style: TextStyle(fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade700,
            ),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                // pushAndRemoveUntil menghapus semua halaman sebelumnya dari
                // stack navigasi, supaya tombol back tidak bisa kembali ke
                // halaman yang mestinya sudah terkunci setelah logout.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Keluar (Logout)'),
          ),
        ],
      ),
    );
  }
}
