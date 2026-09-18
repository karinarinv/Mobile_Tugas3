import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api_client.dart';
import '../../core/app_theme.dart';
import '../../core/auth_provider.dart';
import '../../features/auth/login_screen.dart';
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
    _fetchData();
  }

  void _fetchData() {
    final token = context.read<AuthProvider>().token ?? '';
    setState(() {
      _future = ApiClient.getPasienList(token);
    });
  }

  void _logout() {
    context.read<AuthProvider>().logout();
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
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(existing == null ? 'Tambah Pasien' : 'Ubah Pasien'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: 'Nama Pasien'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ketCtrl,
              decoration: const InputDecoration(labelText: 'Keterangan'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
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

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (existing == null) {
        await ApiClient.createPasien(token, p);
      } else {
        await ApiClient.updatePasien(token, p);
      }

      if (mounted) {
        Navigator.pop(context);
        _fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan')),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  Future<void> _hapus(Pasien p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
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

    final token = context.read<AuthProvider>().token!;
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
      backgroundColor: KlinikBidanPalette.background,
      appBar: AppBar(
        title: const Text('Data Pasien Klinik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchData,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _formDialog(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
      ),
      body: FutureBuilder<List<Pasien>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            final err = snap.error.toString();
            final isAuthError = err.contains('Sesi') || err.contains('401') || err.contains('login');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: KlinikBidanPalette.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: KlinikBidanPalette.border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline_rounded, size: 48, color: Colors.orange.shade400),
                      const SizedBox(height: 12),
                      Text(
                        err,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: KlinikBidanPalette.textPrimary, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: isAuthError ? _logout : _fetchData,
                        icon: Icon(isAuthError ? Icons.login_rounded : Icons.refresh_rounded),
                        label: Text(isAuthError ? 'Kembali ke Login' : 'Coba Lagi'),
                      ),
                    ],
                  ),
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 84),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: KlinikBidanPalette.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: KlinikBidanPalette.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: KlinikBidanPalette.lightGreen,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.group_rounded, color: KlinikBidanPalette.darkGreen),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total pasien', style: TextStyle(color: KlinikBidanPalette.textSecondary, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${list.length}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: KlinikBidanPalette.textPrimary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...list.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: KlinikBidanPalette.lightPink,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.person_rounded, color: KlinikBidanPalette.darkGreen),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.nama,
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: KlinikBidanPalette.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  p.keterangan == null || p.keterangan!.isEmpty ? 'Belum ada keterangan' : p.keterangan!,
                                  style: const TextStyle(color: KlinikBidanPalette.textSecondary, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_note_rounded, color: KlinikBidanPalette.darkGreen),
                                onPressed: () => _formDialog(existing: p),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFB42318)),
                                onPressed: () => _hapus(p),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
