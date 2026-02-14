import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/pomodoro_session.dart';
import '../domain/session_repository.dart';

class SharedPrefsSessionRepository implements SessionRepository {
  static const _key = 'sessions';

  @override
  Future<void> addSession(PomodoroSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await loadSessions();

    sessions.add(session);

    final jsonList =
    sessions.map((s) => s.toJson()).toList();

    await prefs.setString(_key, jsonEncode(jsonList));
  }

  @override
  Future<List<PomodoroSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);

    return decoded
        .map((e) => PomodoroSession.fromJson(e))
        .toList();
  }
}