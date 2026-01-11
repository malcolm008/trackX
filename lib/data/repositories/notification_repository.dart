import 'dart:async';
import '../models/notification/notification_model.dart';
import 'base_repository.dart';
import '../../core/enums/app_enums.dart';

abstract class NotificationRepository extends BaseRepository<NotificationModel> {
  Future<List<NotificationModel>> getNotificationsByUser(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<int> getUnreadCount(String userId);
  Future<void> sendNotification(NotificationModel notification);
  Future<List<NotificationModel>> getNotificationsByType(NotificationType type, String userId);
  Future<void> deleteAllRead(String userId);
  Future<void> scheduleNotification(NotificationModel notification, DateTime scheduleTime);
}

class MockNotificationRepository implements NotificationRepository {
  final List<NotificationModel> _notifications = [];

  @override
  Future<List<NotificationModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredNotifications = List<NotificationModel>.from(_notifications);

    if (filters != null) {
      if (filters.containsKey('userId')) {
        final userId = filters['userId'] as String;
        filteredNotifications = filteredNotifications.where((notif) => notif.userId == userId).toList();
      }

      if (filters.containsKey('type')) {
        final type = filters['type'] as NotificationType;
        filteredNotifications = filteredNotifications.where((notif) => notif.type == type).toList();
      }

      if (filters.containsKey('isRead')) {
        final isRead = filters['isRead'] as bool;
        filteredNotifications = filteredNotifications.where((notif) => notif.isRead == isRead).toList();
      }

      if (filters.containsKey('priority')) {
        final priority = filters['priority'] as NotificationPriority;
        filteredNotifications = filteredNotifications.where((notif) => notif.priority == priority).toList();
      }
    }

    return filteredNotifications;
  }

  @override
  Future<NotificationModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _notifications.firstWhere((notif) => notif.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<NotificationModel> create(NotificationModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications.add(item);
    return item;
  }

  @override
  Future<NotificationModel> update(String id, NotificationModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _notifications.indexWhere((notif) => notif.id == id);
    if (index != -1) {
      _notifications[index] = item;
      return item;
    }

    throw RepositoryFailure('Notification not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _notifications.length;
    _notifications.removeWhere((notif) => notif.id == id);

    return _notifications.length < initialLength;
  }

  @override
  Stream<List<NotificationModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_notifications);
  }

  @override
  Stream<NotificationModel?> watchById(String id) {
    try {
      final notification = _notifications.firstWhere((notif) => notif.id == id);
      return Stream.value(notification);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<List<NotificationModel>> getNotificationsByUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _notifications.where((notif) => notif.userId == userId).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final notification = _notifications.firstWhere((notif) => notif.id == notificationId);
    if (notification != null) {
      final index = _notifications.indexOf(notification);
      _notifications[index] = notification.copyWith(
        isRead: true,
        readAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    for (int i = 0; i < _notifications.length; i++) {
      if (_notifications[i].userId == userId && !_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(
          isRead: true,
          readAt: DateTime.now(),
        );
      }
    }
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _notifications
        .where((notif) => notif.userId == userId && !notif.isRead)
        .length;
  }

  @override
  Future<void> sendNotification(NotificationModel notification) async {
    await Future.delayed(const Duration(milliseconds: 300));
    await create(notification);
  }

  @override
  Future<List<NotificationModel>> getNotificationsByType(NotificationType type, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _notifications.where((notif) =>
    notif.type == type && notif.userId == userId
    ).toList();
  }

  @override
  Future<void> deleteAllRead(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    _notifications.removeWhere((notif) =>
    notif.userId == userId && notif.isRead
    );
  }

  @override
  Future<void> scheduleNotification(NotificationModel notification, DateTime scheduleTime) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final scheduledNotification = notification.copyWith(
      scheduledFor: scheduleTime,
    );

    await create(scheduledNotification);

    // Schedule the notification delivery
    final delay = scheduleTime.difference(DateTime.now());
    if (delay.inMilliseconds > 0) {
      Timer(delay, () async {
        // In real implementation, this would trigger push notification
        print('Scheduled notification delivered: ${notification.title}');
      });
    }
  }
}