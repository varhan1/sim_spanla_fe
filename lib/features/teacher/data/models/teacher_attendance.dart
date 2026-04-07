import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teacher_attendance.g.dart';

@JsonSerializable()
class TeacherAttendance extends Equatable {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String date;
  final String status; // 'hadir' or 'tidak_hadir'
  final String? reason;
  final String? description;
  final String? attachment;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const TeacherAttendance({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    this.reason,
    this.description,
    this.attachment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherAttendance.fromJson(Map<String, dynamic> json) =>
      _$TeacherAttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherAttendanceToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    status,
    reason,
    description,
    attachment,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class CheckInStatusResponse extends Equatable {
  @JsonKey(name: 'has_checked_in')
  final bool hasCheckedIn;
  @JsonKey(name: 'is_present')
  final bool? isPresent;
  final String? reason;

  const CheckInStatusResponse({
    required this.hasCheckedIn,
    this.isPresent,
    this.reason,
  });

  factory CheckInStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckInStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInStatusResponseToJson(this);

  @override
  List<Object?> get props => [hasCheckedIn, isPresent, reason];
}
