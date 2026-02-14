import '../domain/pomodoro_settings.dart';

class PomodoroState {
  final bool isRunning;
  final bool isWorkTime;
  final bool isLongBreak;
  //final int updateWorkMinutes;
  //final int updateShortBreakMinutes;
  //final int updateLongBreakMinutes;
  final int remainingSeconds;
  final int completedPomodoros;
  final int totalSeconds;
  final PomodoroSettings settings;
  final DateTime? targetTime;

  const PomodoroState({
    required this.isRunning,
    required this.isWorkTime,
    required this.isLongBreak,
    //required this.updateWorkMinutes,
    //required this.updateLongBreakMinutes,
    //required this.updateShortBreakMinutes,
    required this.remainingSeconds,
    required this.completedPomodoros,
    required this.totalSeconds,
    required this.settings,
    required this.targetTime
  });

  PomodoroState copyWith({
    bool? isRunning,
    bool? isWorkTime,
    bool? isLongBreak,
   // int? updateWorkMinutes,
   // int? updateLongBreakMinutes,
   // int? updateShortBreakMinutes,
    int? remainingSeconds,
    int? completedPomodoros,
    int? totalSeconds,
    PomodoroSettings? settings,
    DateTime? targetTime,
  }) {
    return PomodoroState(
      isRunning: isRunning ?? this.isRunning,
      isWorkTime: isWorkTime ?? this.isWorkTime,
      isLongBreak: isLongBreak ?? this.isLongBreak,
     // updateWorkMinutes: updateWorkMinutes ?? this.updateWorkMinutes,
     // updateLongBreakMinutes: updateLongBreakMinutes ?? this.updateLongBreakMinutes,
     // updateShortBreakMinutes: updateShortBreakMinutes ?? this.updateShortBreakMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      completedPomodoros:
      completedPomodoros ?? this.completedPomodoros,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      settings: settings ?? this.settings,
      targetTime: targetTime ?? this.targetTime
    );
  }

  String get formattedTime {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
