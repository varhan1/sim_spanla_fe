import 'package:equatable/equatable.dart';
import '../../data/models/teacher_attendance.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

/// Loading state
class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

/// Check-in status loaded successfully
class AttendanceStatusLoaded extends AttendanceState {
  final bool hasCheckedIn;
  final bool? isPresent;
  final String? reason;

  const AttendanceStatusLoaded({
    required this.hasCheckedIn,
    this.isPresent,
    this.reason,
  });

  @override
  List<Object?> get props => [hasCheckedIn, isPresent, reason];
}

/// Check-in submitted successfully
class AttendanceCheckInSuccess extends AttendanceState {
  final TeacherAttendance attendance;

  const AttendanceCheckInSuccess({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

/// Error state
class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError({required this.message});

  @override
  List<Object?> get props => [message];
}
