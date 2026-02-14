import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/pomodoro_notifier.dart';
import '../application/pomodoro_state.dart';
import 'repository_provider.dart';
import 'notification_provider.dart';
import 'session_repository_provider.dart';

final pomodoroProvider =
StateNotifierProvider<PomodoroNotifier, PomodoroState>(
      (ref) {
    final repo = ref.watch(settingsRepositoryProvider);
    final notif = ref.watch(notificationServiceProvider);
    final sessionRepo = ref.watch(sessionRepositoryProvider);

    return PomodoroNotifier(repo, notif, sessionRepo);
  },
);