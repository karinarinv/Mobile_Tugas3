import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _sw = Stopwatch();
  Timer? _ticker;

  final List<Duration> _laps = [];
  int demoStartHour = 1;
  int demoStartSecond = 2;
  int demoStartMinutes = 3; //ganti startnya

  Duration get initialTime {
    return Duration(
      hours: demoStartHour,
      minutes: demoStartMinutes,
      seconds: demoStartSecond,
    );
  }

  Duration get currentTime {
    return initialTime + _sw.elapsed;
  }

  void _start() {
    if (!_sw.isRunning) {
      _sw.start();
    }

    _ticker ??= Timer.periodic(
      const Duration(milliseconds: 100),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );

    setState(() {});
  }

  void _pause() {
    _sw.stop();
    setState(() {});
  }

  void _reset() {
    _sw
      ..stop()
      ..reset();

    _laps.clear();

    setState(() {});
  }

  void _lap() {
    if (_sw.elapsedMilliseconds > 0) {
      setState(() {
        _laps.insert(0, currentTime);
      });
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    final tenths = (duration.inMilliseconds % 1000) ~/ 100;

    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${twoDigits(hours)}:'
        '${twoDigits(minutes)}:'
        '${twoDigits(seconds)}.'
        '$tenths';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch Kontraksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // =========================
            // DISPLAY STOPWATCH
            // =========================
            Text(
              _formatDuration(currentTime),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Ukur durasi dan jarak antar kontraksi',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // BUTTON
            // =========================
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton(
                  onPressed: _start,
                  child: const Text('Mulai'),
                ),
                FilledButton(
                  onPressed: _pause,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text('Jeda'),
                ),
                FilledButton(
                  onPressed: _lap,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.pink,
                  ),
                  child: const Text('Catat'),
                ),
                OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================
            // RIWAYAT KONTRAKSI
            // =========================
            Expanded(
              child: _laps.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada catatan kontraksi',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _laps.length,
                      itemBuilder: (context, index) {
                        final current = _laps[index];

                        Duration interval;

                        if (index + 1 < _laps.length) {
                          interval = current - _laps[index + 1];
                        } else {
                          interval = current;
                        }

                        return ListTile(
                          dense: true,
                          title: Text(
                            'Kontraksi #${_laps.length - index}',
                          ),
                          trailing: Text(
                            '${_formatDuration(current)} '
                            '(+${_formatDuration(interval)})',
                          ),
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
