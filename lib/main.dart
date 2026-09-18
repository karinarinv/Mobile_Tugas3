import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'app_shell.dart';

class KlinikBidanPalette {
  static const softPink = Color(0xFFF6B6C8);
  static const lightPink = Color(0xFFFCE4EC);
  static const pastelGreen = Color(0xFFB8DCC8);
  static const lightGreen = Color(0xFFE8F3EC);
  static const darkGreen = Color(0xFF356859);
  static const textPrimary = Color(0xFF344054);
  static const textSecondary = Color(0xFF667085);
  static const background = Color(0xFFFAFAF8);
  static const white = Color(0xFFFFFFFF);
  static const border = Color(0xFFE7E8E3);
}

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
    final baseTextTheme = ThemeData.light().textTheme;
    final textTheme = GoogleFonts.poppinsTextTheme(baseTextTheme)
        .apply(bodyColor: KlinikBidanPalette.textPrimary, displayColor: KlinikBidanPalette.textPrimary);

    return MaterialApp(
      title: 'Klinik Bidan Sehati',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: KlinikBidanPalette.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: KlinikBidanPalette.softPink,
          brightness: Brightness.light,
          primary: KlinikBidanPalette.softPink,
          secondary: KlinikBidanPalette.pastelGreen,
          tertiary: KlinikBidanPalette.lightGreen,
          background: KlinikBidanPalette.background,
          surface: KlinikBidanPalette.white,
        ),
        textTheme: textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: KlinikBidanPalette.white,
          foregroundColor: KlinikBidanPalette.textPrimary,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: KlinikBidanPalette.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: KlinikBidanPalette.border, width: 1),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: KlinikBidanPalette.white,
          indicatorColor: KlinikBidanPalette.lightPink,
          surfaceTintColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: KlinikBidanPalette.textPrimary,
            );
          }),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: KlinikBidanPalette.darkGreen,
          foregroundColor: KlinikBidanPalette.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: KlinikBidanPalette.lightGreen,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: KlinikBidanPalette.softPink, width: 1.5),
          ),
          hintStyle: const TextStyle(color: KlinikBidanPalette.textSecondary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: KlinikBidanPalette.softPink,
            foregroundColor: KlinikBidanPalette.textPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: KlinikBidanPalette.darkGreen,
            foregroundColor: KlinikBidanPalette.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      home: const _RootDecider(),
      routes: {
        '/home': (_) => const AppShell(),
        '/login': (_) => const LoginScreen(),
      },
    );
  }
}

class _RootDecider extends StatelessWidget {
  const _RootDecider();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.checking) {
      return const Scaffold(
        backgroundColor: KlinikBidanPalette.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return auth.isLoggedIn ? const AppShell() : const LoginScreen();
  }
}

