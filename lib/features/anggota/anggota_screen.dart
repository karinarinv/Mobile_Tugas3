import 'package:flutter/material.dart';

class AnggotaScreen extends StatelessWidget {
  const AnggotaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const anggota = [
      ['Aleyda Azkia Firani M.', 'NIM 22081010… · UI/UX & Frontend'],
      ['Anggota Kelompok 2', 'NIM 22081010… · Database & Backend'],
      ['Anggota Kelompok 3', 'NIM 22081010… · Fitur Konversi & Laporan'],
      ['Anggota Kelompok 4', 'NIM 22081010… · Pengujian & Dokumentasi'],
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Anggota Kelompok')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: anggota.length,
        itemBuilder: (context, i) => Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${i + 1}')),
            title: Text(anggota[i][0]),
            subtitle: Text(anggota[i][1]),
          ),
        ),
      ),
    );
  }
}
