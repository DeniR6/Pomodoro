import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/pomodoro_settings.dart';
import '../providers/pomodoro_provider.dart';

class PomodoroPage extends ConsumerStatefulWidget {
  const PomodoroPage({super.key});

  @override
  ConsumerState<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends ConsumerState<PomodoroPage> {
  late final TextEditingController workController;
  late final TextEditingController breakController;
  late final TextEditingController longController;

  @override
  void initState() {
    super.initState();
    workController = TextEditingController(text: '25');
    breakController = TextEditingController(text: '5');
    longController = TextEditingController(text: '15');
  }

  @override
  void dispose() {
    workController.dispose();
    breakController.dispose();
    longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pomodoroProvider);
    final notifier = ref.read(pomodoroProvider.notifier);

    /// 🎨 Phasenfarbe
    final Color phaseColor = state.isWorkTime
        ? Colors.deepPurple
        : state.isLongBreak
        ? Colors.blue
        : Colors.green;

    /// Progress Berechnung
    final int maxSeconds = state.isWorkTime
        ? state.settings.workMinutes * 60
        : state.isLongBreak
        ? state.settings.longBreakMinutes * 60
        : state.settings.shortBreakMinutes * 60;

    final double progress =
    maxSeconds == 0 ? 0 : state.remainingSeconds / maxSeconds;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      color: phaseColor.withOpacity(0.06),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// PHASE TITLE
              Text(
                state.isWorkTime
                    ? 'Arbeitszeit 🍅'
                    : state.isLongBreak
                    ? 'Lange Pause 🌴'
                    : 'Pause ☕',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              /// PROGRESS CIRCLE
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 32,
                      strokeAlign: 5,
                      backgroundColor: phaseColor.withOpacity(0.15),
                      valueColor:
                      AlwaysStoppedAnimation<Color>(phaseColor),
                    ),
                    Text(
                      state.formattedTime,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// START / RESET BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: phaseColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                    state.isRunning ? notifier.pause : notifier.start,
                    child: Text(
                      state.isRunning ? 'Pause' : 'Start',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: notifier.reset,
                    child: const Text('Reset'),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// SETTINGS CARD
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Einstellungen",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: workController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Arbeitszeit (Minuten)',
                        ),
                      ),
                      TextField(
                        controller: breakController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Pause (Minuten)',
                        ),
                      ),
                      TextField(
                        controller: longController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Lange Pause (Minuten)',
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white38,
                          minimumSize:
                          const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          notifier.updateSettings(
                            PomodoroSettings(
                              workMinutes:
                              int.tryParse(workController.text) ??
                                  25,
                              shortBreakMinutes:
                              int.tryParse(breakController.text) ??
                                  5,
                              longBreakMinutes:
                              int.tryParse(longController.text) ??
                                  15,
                              longBreakInterval: 4,
                            ),
                          );
                        },
                        child: const Text("Übernehmen", style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}