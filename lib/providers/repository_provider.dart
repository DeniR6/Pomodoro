import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/settings_repository.dart';
import '../infrastructure/shared_prefs_settings_repository.dart';

final settingsRepositoryProvider =
Provider<SettingsRepository>((ref) {
  return SharedPrefsSettingsRepository();
});