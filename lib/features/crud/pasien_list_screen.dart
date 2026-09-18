import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth_provider.dart';
import '../../core/api_client.dart';
import '../../models/pasien.dart';
import '../../features/auth/login_screen.dart';


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
    _fetchData();
  }

  void _fetchData() {
    final token = context.read<AuthProvider>().token ?? '';
    setState(() {
      _future = ApiClient.getPasienList(token);
    });
  }

  void _logout() {
  // 1. Reset state & token di AuthProvider
  context.read<AuthProvider>().logout();

  // 2. Bersihkan tumpukan navigasi dan balik ke RootDecider (LoginScreen)
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (route) => false,
  );
}

  Future<void> _formDialog({Pasien? existing}) async {
    final namaCtrl = TextEditingController(text: existing?.nama ?? '');
    final ketCtrl = TextEditingController(text: existing?.keterangan ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Tambah Pasien' : 'Ubah Pasien'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: 'Nama Pasien'),
            ),
            TextField(
              controller: ketCtrl,
              decoration: const InputDecoration(labelText: 'Keterangan'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (ok != true || namaCtrl.text.trim().isEmpty) return;

    final token = context.read<AuthProvider>().token ?? '';
    final p = Pasien(
      id: existing?.id,
      nama: namaCtrl.text.trim(),
      keterangan: ketCtrl.text.trim(),
    );

    try {
      if (existing == null) {
        await ApiClient.createPasien(token, p);
      } else {
        await ApiClient.updatePasien(token, p);
      }
      _fetchData();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  Future<void> _hapus(Pasien p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus pasien?'),
        content: Text('Hapus data "${p.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true || p.id == null) return;

    final token = context.read<AuthProvider>().token ?? '';
    try {
      await ApiClient.deletePasien(token, p.id!);
      _fetchData();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pasien Klinik'),
        backgroundColor: const Color(0xFF0B5C55),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
          // Tombol Logout manual di AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0B5C55),
        foregroundColor: Colors.white,
        onPressed: () => _formDialog(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Pasien>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            final err = snap.error.toString();
            // Jika error berisi kata 'Sesi' atau '401', beri tombol ke Login
            final isAuthError = err.contains('Sesi') || err.contains('401') || err.contains('login');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.orange, size: 50),
                    const SizedBox(height: 12),
                    Text(
                      err,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B5C55),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isAuthError ? _logout : _fetchData,
                      icon: Icon(isAuthError ? Icons.login : Icons.refresh),
                      label: Text(isAuthError ? 'Kembali ke Login' : 'Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final list = snap.data ?? [];
          if (list.isEmpty) {
            return const Center(
              child: Text('Belum ada data pasien.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchData(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final p = list[i];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF0B5C55),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      p.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      p.keterangan == null || p.keterangan!.isEmpty
                          ? '-'
                          : p.keterangan!,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _formDialog(existing: p),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _hapus(p),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}