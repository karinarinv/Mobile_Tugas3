import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api_client.dart';
import '../../core/app_theme.dart';
import '../../core/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController(text: 'bidan_asti');
  final _passCtrl = TextEditingController(text: 'password123');
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().login(
        _userCtrl.text.trim(),
        _passCtrl.text,
      );

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
        );
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Tidak dapat terhubung ke server. Cek baseUrl di api_client.dart.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KlinikBidanPalette.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: KlinikBidanPalette.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB8DCC8).withOpacity(0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: KlinikBidanPalette.lightPink,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(Icons.local_hospital_rounded,
                          color: KlinikBidanPalette.darkGreen, size: 42),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Klinik Bidan Sehati',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: KlinikBidanPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sistem Informasi & Layanan Pemeriksaan',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KlinikBidanPalette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _userCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Username / ID Bidan',
                        prefixIcon: Icon(Icons.person_outline_rounded, color: KlinikBidanPalette.darkGreen),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline_rounded, color: KlinikBidanPalette.darkGreen),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_error != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF5C2CB)),
                        ),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFB42318), fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: KlinikBidanPalette.white,
                                ),
                              )
                            : const Text('Masuk Aplikasi'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: KlinikBidanPalette.lightGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Demo: bidan_asti / password123',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: KlinikBidanPalette.darkGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
