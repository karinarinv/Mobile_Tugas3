import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Stopwatch memakai dart:core Stopwatch sebagai sumber waktu -
/// Timer.periodic HANYA dipakai untuk memicu redraw tampilan setiap
/// 100ms, bukan sebagai penghitung waktu itu sendiri. Ini mencegah
/// drift/melenceng yang muncul kalau waktu dihitung dengan menambah
/// counter di tiap tick timer.
class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});
  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final _sw = Stopwatch();
  Timer? _ticker;
  final List<Duration> _laps = [];

  void _start() {
    _sw.start();
    _ticker ??= Timer.periodic(const Duration(milliseconds: 100), (_) => setState(() {}));
  }

  void _pause() => setState(() => _sw.stop());

  void _reset() {
    _sw
      ..stop()
      ..reset();
    _laps.clear();
    setState(() {});
  }

  void _lap() {
    if (_sw.elapsed.inMilliseconds > 0) {
      setState(() => _laps.insert(0, _sw.elapsed));
    }
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    final ds = (d.inMilliseconds % 1000) ~/ 100;
    return '${two(h)}:${two(m)}:${two(s)}.$ds';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch Kontraksi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              _fmt(_sw.elapsed),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 8),
            const Text('Ukur durasi dan jarak antar kontraksi', style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 20),
            Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
              FilledButton(onPressed: _start, child: const Text('Mulai')),
              FilledButton(
                  onPressed: _pause,
                  style: FilledButton.styleFrom(backgroundColor: Colors.amber.shade700),
                  child: const Text('Jeda')),
              FilledButton(
                  onPressed: _lap,
                  style: FilledButton.styleFrom(backgroundColor: Colors.pink.shade700),
                  child: const Text('Catat')),
              OutlinedButton(onPressed: _reset, child: const Text('Reset')),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: _laps.isEmpty
                  ? const Center(child: Text('Belum ada catatan kontraksi', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _laps.length,
                      itemBuilder: (context, i) {
                        final prev = i + 1 < _laps.length ? _laps[i + 1] : Duration.zero;
                        return ListTile(
                          dense: true,
                          title: Text('Kontraksi #${_laps.length - i}'),
                          trailing: Text('${_fmt(_laps[i])}  (+${_fmt(_laps[i] - prev)})'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
