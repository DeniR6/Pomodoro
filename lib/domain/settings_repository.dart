import 'pomodoro_settings.dart';

abstract class SettingsRepository {
  Future<PomodoroSettings> loadSettings();
  Future<void> saveSettings(PomodoroSettings settings);
}