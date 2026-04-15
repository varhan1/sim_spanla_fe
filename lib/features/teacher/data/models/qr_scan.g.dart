// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_scan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceCategory _$AttendanceCategoryFromJson(Map<String, dynamic> json) =>
    AttendanceCategory(
      id: json['kode'] as String,
      name: json['label'] as String,
    );

Map<String, dynamic> _$AttendanceCategoryToJson(AttendanceCategory instance) =>
    <String, dynamic>{
      'kode': instance.id,
      'label': instance.name,
    };

ActivityGroup _$ActivityGroupFromJson(Map<String, dynamic> json) =>
    ActivityGroup(
      activity: json['activity'] as String,
      scanTypes: (json['scan_types'] as List<dynamic>)
          .map((e) => AttendanceCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivityGroupToJson(ActivityGroup instance) =>
    <String, dynamic>{
      'activity': instance.activity,
      'scan_types': instance.scanTypes,
    };

ScanRequest _$ScanRequestFromJson(Map<String, dynamic> json) => ScanRequest(
      qrCode: json['qr_code'] as String,
      type: json['type'] as String,
      kegiatan: json['kegiatan'] as String?,
    );

Map<String, dynamic> _$ScanRequestToJson(ScanRequest instance) =>
    <String, dynamic>{
      'qr_code': instance.qrCode,
      'type': instance.type,
      'kegiatan': instance.kegiatan,
    };

ScanResponse _$ScanResponseFromJson(Map<String, dynamic> json) => ScanResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : ScanResultData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScanResponseToJson(ScanResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ScanResultData _$ScanResultDataFromJson(Map<String, dynamic> json) =>
    ScanResultData(
      attendanceId: (json['attendance_id'] as num?)?.toInt(),
      student: json['student'] == null
          ? null
          : StudentInfo.fromJson(json['student'] as Map<String, dynamic>),
      category: json['category'] as String?,
      scannedAt: json['scanned_at'] as String?,
    );

Map<String, dynamic> _$ScanResultDataToJson(ScanResultData instance) =>
    <String, dynamic>{
      'attendance_id': instance.attendanceId,
      'student': instance.student,
      'category': instance.category,
      'scanned_at': instance.scannedAt,
    };

StudentInfo _$StudentInfoFromJson(Map<String, dynamic> json) => StudentInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nisn: json['nisn'] as String,
      nis: json['nis'] as String?,
      className: json['class_name'] as String?,
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$StudentInfoToJson(StudentInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nisn': instance.nisn,
      'nis': instance.nis,
      'class_name': instance.className,
      'photo_url': instance.photoUrl,
    };

ScanHistoryItem _$ScanHistoryItemFromJson(Map<String, dynamic> json) =>
    ScanHistoryItem(
      student: StudentInfo.fromJson(json['student'] as Map<String, dynamic>),
      category: json['category'] as String,
      scannedAt: json['scanned_at'] as String,
    );

Map<String, dynamic> _$ScanHistoryItemToJson(ScanHistoryItem instance) =>
    <String, dynamic>{
      'student': instance.student,
      'category': instance.category,
      'scanned_at': instance.scannedAt,
    };
