class PomodoroSession {
  final DateTime completedAt;
  final int durationMinutes;

  PomodoroSession({
    required this.completedAt,
    required this.durationMinutes,
  });

  Map<String, dynamic> toJson() => {
    'completedAt': completedAt.toIso8601String(),
    'durationMinutes': durationMinutes,
  };

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      completedAt: DateTime.parse(json['completedAt']),
      durationMinutes: json['durationMinutes'],
    );
  }
}