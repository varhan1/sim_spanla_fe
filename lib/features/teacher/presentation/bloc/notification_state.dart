part of 'notification_bloc.dart';

class NotificationState {
  final int unreadCount;
  final bool connected;

  const NotificationState({required this.unreadCount, required this.connected});

  factory NotificationState.initial() =>
      const NotificationState(unreadCount: 0, connected: false);

  NotificationState copyWith({int? unreadCount, bool? connected}) {
    return NotificationState(
      unreadCount: unreadCount ?? this.unreadCount,
      connected: connected ?? this.connected,
    );
  }
}
