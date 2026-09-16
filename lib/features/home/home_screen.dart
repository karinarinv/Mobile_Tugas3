import 'package:flutter/material.dart';
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

/// Halaman Utama: 5 menu vertikal di tengah layar sesuai kriteria tugas.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      _MenuItem('1. Daftar Anggota Kelompok', 'Profil dan pembagian tugas tim',
          Icons.groups, const AnggotaScreen()),
      _MenuItem('2. Komputasi Tema — HPL', 'Hitung perkiraan lahir & usia kehamilan',
          Icons.calculate, const KomputasiScreen()),
      _MenuItem('3. CRUD Data Pasien', 'Tambah, ubah, hapus data pasien',
          Icons.folder_shared, const PasienListScreen()),
      _MenuItem('4. Konversi Umur Detail', 'Tahun, bulan, hari, jam, menit, detik',
          Icons.hourglass_bottom, const UmurScreen()),
      _MenuItem('5. Kalender Weton, Saka & Hijriah', 'Konversi Jawa, Bali & Islam',
          Icons.calendar_month, const KalenderScreen()),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
              title: Text('Bidan Asti, S.Tr.Keb', style: TextStyle(fontSize: 15)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _MenuTile(item: menus[i]),
                childCount: menus.length,
              ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(child: Icon(item.icon)),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.page)),
      ),
    );
  }
}
