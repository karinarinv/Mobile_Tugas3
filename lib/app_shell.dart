import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'features/stopwatch/stopwatch_screen.dart';
import 'features/bantuan/bantuan_screen.dart';

/// Bottom Navigation Bar dengan 3 menu: Utama, Stopwatch, Bantuan.
///
/// IndexedStack menjaga state tiap tab tetap hidup saat berpindah -
/// penting supaya stopwatch TIDAK reset ke 00:00 saat pindah ke tab
/// lain lalu kembali lagi.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    StopwatchScreen(),
    BantuanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Utama'),
          NavigationDestination(
              icon: Icon(Icons.timer_outlined), selectedIcon: Icon(Icons.timer), label: 'Stopwatch'),
          NavigationDestination(
              icon: Icon(Icons.help_outline), selectedIcon: Icon(Icons.help), label: 'Bantuan'),
        ],
      ),
    );
  }
}
