import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro/domain/session_repository.dart';
import 'package:pomodoro/infrastructure/shared_prefs_session_repository.dart';
import '../domain/pomodoro_settings.dart';
import '../domain/settings_repository.dart';
import '../infrastructure/notification_service.dart';
import '../infrastructure/shared_prefs_session_repository.dart';
import '../infrastructure/shared_prefs_settings_repository.dart';
import 'pomodoro_state.dart';
import '../domain/pomodoro_session.dart';
import '../domain/session_repository.dart';
import '../domain/settings_repository.dart';


class PomodoroNotifier extends StateNotifier<PomodoroState> {
  final SettingsRepository repository;
  final NotificationService notificationService;
  final SessionRepository sessionRepository;


  Timer? _timer;

  PomodoroNotifier(
      this.repository,
      this.notificationService,
      this.sessionRepository,
      ) : super(
    PomodoroState(
      totalSeconds: 1500,
      isRunning: false,
      isWorkTime: true,
      isLongBreak: false,
      remainingSeconds: 25 * 60,
      completedPomodoros: 0,
      targetTime: null,
      settings: const PomodoroSettings(
        workMinutes: 25,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
        longBreakInterval: 4,
      ),
    ),
  ) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await repository.loadSettings();

    state = state.copyWith(
      settings: settings,
      remainingSeconds: settings.workSeconds,
    );
  }

  Future<void> updateSettings(PomodoroSettings newSettings) async {
    await repository.saveSettings(newSettings);

    pause();

    state = state.copyWith(
      settings: newSettings,
      remainingSeconds: newSettings.workSeconds,
      isWorkTime: true,
      isLongBreak: false,
      completedPomodoros: 0,
      targetTime: null,
    );
  }

  // ================================
  // TIMER CONTROL
  // ================================

  void start() {
    if (state.isRunning) return;

    final now = DateTime.now();
    final target =
    now.add(Duration(seconds: state.remainingSeconds));

    state = state.copyWith(
      isRunning: true,
      targetTime: target,
    );

    notificationService.scheduleNotification(target);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _updateRemaining(),
    );
  }

  void pause() {
    _timer?.cancel();
    _timer = null;

    notificationService.cancel();

    if (state.targetTime != null) {
      final diff =
          state.targetTime!.difference(DateTime.now()).inSeconds;

      state = state.copyWith(
        isRunning: false,
        remainingSeconds: diff > 0 ? diff : 0,
        targetTime: null,
      );
    }
  }

  void reset() {
    pause();

    state = state.copyWith(
      isWorkTime: true,
      isLongBreak: false,
      remainingSeconds: state.settings.workSeconds,
      completedPomodoros: 0,
    );
  }

  void _updateRemaining() {
    if (state.targetTime == null) return;

    final diff =
        state.targetTime!.difference(DateTime.now()).inSeconds;

    if (diff > 0) {
      state = state.copyWith(remainingSeconds: diff);
    } else {
      _switchPhase();
    }
  }

  // ================================
  // PHASE SWITCHING
  // ================================

  Future<void> _switchPhase() async {
    notificationService.cancel();

    if (state.isWorkTime) {
      final completed = state.completedPomodoros + 1;

      await sessionRepository.addSession(
        PomodoroSession(
          completedAt: DateTime.now(),
          durationMinutes: state.settings.workMinutes,
        ),
      );

      final isLong =
          completed % state.settings.longBreakInterval == 0;

      final nextDuration = isLong
          ? state.settings.longBreakSeconds
          : state.settings.shortBreakSeconds;

      state = state.copyWith(
        isWorkTime: false,
        isLongBreak: isLong,
        completedPomodoros: completed,
        remainingSeconds: nextDuration,
        totalSeconds: nextDuration,
        isRunning: false,
        targetTime: null,
      );
    } else {
      state = state.copyWith(
        isWorkTime: true,
        isLongBreak: false,
        remainingSeconds: state.settings.workSeconds,
        totalSeconds: null,
        isRunning: false,
        targetTime: null,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}