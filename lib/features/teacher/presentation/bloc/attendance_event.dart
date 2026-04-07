import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check teacher's check-in status for today
class CheckAttendanceStatus extends AttendanceEvent {
  const CheckAttendanceStatus();
}

/// Event to submit teacher check-in
class SubmitCheckIn extends AttendanceEvent {
  final String status; // 'hadir' or 'tidak_hadir'
  final String? reason;
  final String? description;

  const SubmitCheckIn({required this.status, this.reason, this.description});

  @override
  List<Object?> get props => [status, reason, description];
}
