import 'package:shared_preferences/shared_preferences.dart';
import '../domain/pomodoro_settings.dart';
import '../domain/settings_repository.dart';

class SharedPrefsSettingsRepository
    implements SettingsRepository {

  @override
  Future<PomodoroSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return PomodoroSettings(
      workMinutes: prefs.getInt('work') ?? 25,
      shortBreakMinutes: prefs.getInt('short') ?? 5,
      longBreakMinutes: prefs.getInt('long') ?? 15,
      longBreakInterval: prefs.getInt('interval') ?? 4,
    );
  }

  @override
  Future<void> saveSettings(PomodoroSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('work', settings.workMinutes);
    await prefs.setInt('short', settings.shortBreakMinutes);
    await prefs.setInt('long', settings.longBreakMinutes);
    await prefs.setInt('interval', settings.longBreakInterval);
  }
}