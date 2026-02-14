import 'pomodoro_session.dart';

abstract class SessionRepository {
  Future<void> addSession(PomodoroSession session);
  Future<List<PomodoroSession>> loadSessions();
}