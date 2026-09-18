import 'package:flutter/material.dart';

class AnggotaScreen extends StatelessWidget {
  const AnggotaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const anggota = [
      ['Putri Karina Tumanggor', 'NIM 124240047'],
      ['Rachma Alycia Nugrahanto', 'NIM 124240072'],
      ['Flavia Domitilla Alva Anggita', 'NIM 124240123 '],
      ['Aleyda Azkia Firani Masyithah', 'NIM 124240130'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota Kelompok'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: anggota.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${i + 1}'),
              ),
              title: Text(anggota[i][0]),
              subtitle: Text(anggota[i][1]),
            ),
          ),
        ),
      ),
    );
  }
}
