import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/session_repository.dart';
import '../infrastructure/shared_prefs_session_repository.dart';

final sessionRepositoryProvider =
Provider<SessionRepository>((ref) {
  return SharedPrefsSessionRepository();
});