import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/stopwatch/stopwatch_screen.dart';
import 'features/bantuan/bantuan_screen.dart';

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
      backgroundColor: KlinikBidanPalette.background,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: const BoxDecoration(
          color: KlinikBidanPalette.background,
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          shadowColor: Colors.black.withOpacity(0.08),
          elevation: 0,
          height: 72,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Utama',
            ),
            NavigationDestination(
              icon: Icon(Icons.timer_outlined),
              selectedIcon: Icon(Icons.timer_rounded),
              label: 'Stopwatch',
            ),
            NavigationDestination(
              icon: Icon(Icons.help_outline_rounded),
              selectedIcon: Icon(Icons.help_rounded),
              label: 'Bantuan',
            ),
          ],
        ),
      ),
    );
  }
}
