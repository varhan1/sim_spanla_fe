// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherAttendance _$TeacherAttendanceFromJson(Map<String, dynamic> json) =>
    TeacherAttendance(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      date: json['date'] as String,
      status: json['status'] as String,
      reason: json['reason'] as String?,
      description: json['description'] as String?,
      attachment: json['attachment'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$TeacherAttendanceToJson(TeacherAttendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'date': instance.date,
      'status': instance.status,
      'reason': instance.reason,
      'description': instance.description,
      'attachment': instance.attachment,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CheckInStatusResponse _$CheckInStatusResponseFromJson(
        Map<String, dynamic> json) =>
    CheckInStatusResponse(
      hasCheckedIn: json['has_checked_in'] as bool,
      isPresent: json['is_present'] as bool?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$CheckInStatusResponseToJson(
        CheckInStatusResponse instance) =>
    <String, dynamic>{
      'has_checked_in': instance.hasCheckedIn,
      'is_present': instance.isPresent,
      'reason': instance.reason,
    };
