part of 'schedule_bloc.dart';

abstract class ScheduleState {
  const ScheduleState();
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleItem> schedules;
  final DateTime selectedDate;
  final String dayName; // e.g., "SENIN"

  const ScheduleLoaded({
    required this.schedules,
    required this.selectedDate,
    required this.dayName,
  });
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);
}
