part of 'schedule_bloc.dart';

abstract class ScheduleEvent {
  const ScheduleEvent();
}

/// Load schedules for a specific date
class LoadSchedules extends ScheduleEvent {
  final String? date; // format: yyyy-MM-dd, null = today

  const LoadSchedules({this.date});
}

/// Change selected date
class ChangeDate extends ScheduleEvent {
  final DateTime date;

  const ChangeDate(this.date);
}
