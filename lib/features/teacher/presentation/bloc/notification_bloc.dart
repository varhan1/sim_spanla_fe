import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/app_notification.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/services/realtime_notification_service.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  final RealtimeNotificationService _realtime;

  NotificationBloc({
    NotificationRepository? repository,
    RealtimeNotificationService? realtime,
  }) : _repository = repository ?? NotificationRepository(),
       _realtime = realtime ?? RealtimeNotificationService(),
       super(NotificationState.initial()) {
    on<NotificationStarted>(_onStarted);
    on<NotificationUnreadRequested>(_onUnreadRequested);
    on<NotificationRealtimeReceived>(_onRealtimeReceived);
    on<NotificationMarkedAllRead>(_onMarkedAllRead);
    on<NotificationStopped>(_onStopped);
  }

  Future<void> _onStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) async {
    await _realtime.connect(
      userId: event.userId,
      onNotification: (notification) {
        add(NotificationRealtimeReceived(notification));
      },
    );

    final count = await _repository.getUnreadCount();
    emit(state.copyWith(unreadCount: count, connected: true));
  }

  Future<void> _onUnreadRequested(
    NotificationUnreadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final count = await _repository.getUnreadCount();
    emit(state.copyWith(unreadCount: count));
  }

  void _onRealtimeReceived(
    NotificationRealtimeReceived event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(unreadCount: state.unreadCount + 1));
  }

  Future<void> _onMarkedAllRead(
    NotificationMarkedAllRead event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.markAllRead();
    emit(state.copyWith(unreadCount: 0));
  }

  Future<void> _onStopped(
    NotificationStopped event,
    Emitter<NotificationState> emit,
  ) async {
    await _realtime.disconnect();
    emit(state.copyWith(connected: false));
  }

  @override
  Future<void> close() async {
    await _realtime.disconnect();
    return super.close();
  }
}
