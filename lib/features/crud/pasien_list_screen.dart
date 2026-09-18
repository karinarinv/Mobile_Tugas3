import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth_provider.dart';
import '../../core/api_client.dart';
import '../../models/pasien.dart';

class PasienListScreen extends StatefulWidget {
  const PasienListScreen({super.key});
  @override
  State<PasienListScreen> createState() => _PasienListScreenState();
}

class _PasienListScreenState extends State<PasienListScreen> {
  late Future<List<Pasien>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final token = context.read<AuthProvider>().token!;
    setState(() => _future = ApiClient.getPasienList(token));
  }

  Future<void> _formDialog({Pasien? existing}) async {
    final namaCtrl = TextEditingController(text: existing?.nama ?? '');
    final ketCtrl = TextEditingController(text: existing?.keterangan ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Tambah Pasien' : 'Ubah Pasien'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama')),
          TextField(controller: ketCtrl, decoration: const InputDecoration(labelText: 'Keterangan')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Simpan')),
        ],
      ),
    );
    if (ok != true || namaCtrl.text.trim().isEmpty) return;

    // ignore: use_build_context_synchronously
    final token = context.read<AuthProvider>().token!;
    final p = Pasien(id: existing?.id, nama: namaCtrl.text.trim(), keterangan: ketCtrl.text.trim());
    try {
      if (existing == null) {
        await ApiClient.createPasien(token, p);
      } else {
        await ApiClient.updatePasien(token, p);
      }
      _reload();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _hapus(Pasien p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus pasien?'),
        content: Text('Hapus data "${p.nama}"? Tindakan ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (confirm != true) return;

    // ignore: use_build_context_synchronously
    final token = context.read<AuthProvider>().token!;
    try {
      await ApiClient.deletePasien(token, p.id!);
      _reload();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Data Pasien')),
      floatingActionButton: FloatingActionButton(onPressed: () => _formDialog(), child: const Icon(Icons.add)),
      body: FutureBuilder<List<Pasien>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('${snap.error}', textAlign: TextAlign.center));
          }
          final list = snap.data ?? [];
          if (list.isEmpty) return const Center(child: Text('Belum ada data pasien.'));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final p = list[i];
              return Card(
                child: ListTile(
                  title: Text(p.nama),
                  subtitle: Text(p.keterangan ?? '-'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _formDialog(existing: p)),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () => _hapus(p)),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
