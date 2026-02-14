import '../domain/pomodoro_session.dart';

class StatisticsService {
  final List<PomodoroSession> sessions;

  StatisticsService(this.sessions);

  int pomodorosToday() {
    final today = DateTime.now();
    return sessions.where((s) =>
    s.completedAt.year == today.year &&
        s.completedAt.month == today.month &&
        s.completedAt.day == today.day).length;
  }

  int totalFocusMinutes() {
    return sessions.fold(
        0, (sum, s) => sum + s.durationMinutes);
  }
  int currentStreak() {
    if (sessions.isEmpty) return 0;

    final sorted = sessions
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    int streak = 0;
    DateTime day = DateTime.now();

    for (var s in sorted) {
      if (_isSameDay(s.completedAt, day)) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      }
    }

    return streak;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  Map<int, int> weeklyOverview() {
    final now = DateTime.now();
    final startOfWeek =
    now.subtract(Duration(days: now.weekday - 1));

    Map<int, int> result = {};

    for (var i = 0; i < 7; i++) {
      result[i] = 0;
    }

    for (var s in sessions) {
      if (s.completedAt.isAfter(startOfWeek)) {
        result[s.completedAt.weekday - 1] =
            (result[s.completedAt.weekday - 1] ?? 0) + 1;
      }
    }

    return result;
  }
}