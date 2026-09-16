import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'app_shell.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..restore(),
      child: const KlinikBidanApp(),
    ),
  );
}

class KlinikBidanApp extends StatelessWidget {
  const KlinikBidanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik Bidan Sehati',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0F766E),
        useMaterial3: true,
      ),
      home: const _RootDecider(),
    );
  }
}

/// Menentukan layar awal: kalau ada token tersimpan -> langsung ke
/// AppShell, kalau tidak -> LoginScreen. Ini logika "splash screen"
/// pengecekan session yang disebutkan di rencana arsitektur.
class _RootDecider extends StatelessWidget {
  const _RootDecider();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.isLoggedIn ? const AppShell() : const LoginScreen();
  }
}
