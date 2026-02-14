import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/notification_service.dart';

final notificationServiceProvider =
Provider<NotificationService>((ref) {
  return NotificationService();
});