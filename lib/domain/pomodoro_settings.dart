class PomodoroSettings {
  final int workMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int longBreakInterval; // z.B. nach 4 Sessions

  const PomodoroSettings({
    required this.workMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.longBreakInterval,
  });

  int get workSeconds => workMinutes * 60;
  int get shortBreakSeconds => shortBreakMinutes * 60;
  int get longBreakSeconds => longBreakMinutes * 60;
}
