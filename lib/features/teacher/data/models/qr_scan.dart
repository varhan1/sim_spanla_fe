import 'package:json_annotation/json_annotation.dart';

part 'qr_scan.g.dart';

/// Attendance category for QR scan
@JsonSerializable()
class AttendanceCategory {
  @JsonKey(name: 'kode')
  final String id;
  @JsonKey(name: 'label')
  final String name;

  const AttendanceCategory({required this.id, required this.name});

  factory AttendanceCategory.fromJson(Map<String, dynamic> json) =>
      _$AttendanceCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceCategoryToJson(this);
}

/// Activity Group containing scan types
@JsonSerializable()
class ActivityGroup {
  final String activity;
  @JsonKey(name: 'scan_types')
  final List<AttendanceCategory> scanTypes;

  const ActivityGroup({required this.activity, required this.scanTypes});

  factory ActivityGroup.fromJson(Map<String, dynamic> json) =>
      _$ActivityGroupFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityGroupToJson(this);
}

/// Request to submit QR scan
@JsonSerializable()
class ScanRequest {
  @JsonKey(name: 'qr_code')
  final String qrCode;
  final String type;
  final String? kegiatan;

  const ScanRequest({required this.qrCode, required this.type, this.kegiatan});

  factory ScanRequest.fromJson(Map<String, dynamic> json) =>
      _$ScanRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ScanRequestToJson(this);
}

/// Response after successful scan
@JsonSerializable()
class ScanResponse {
  final String status;
  final String message;
  final ScanResultData? data;

  const ScanResponse({required this.status, required this.message, this.data});

  factory ScanResponse.fromJson(Map<String, dynamic> json) =>
      _$ScanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResponseToJson(this);

  bool get isSuccess => status == 'success';
}

/// Student data from scan result
@JsonSerializable()
class ScanResultData {
  @JsonKey(name: 'attendance_id')
  final int? attendanceId;
  final StudentInfo? student;
  final String? category;
  @JsonKey(name: 'scanned_at')
  final String? scannedAt;

  const ScanResultData({
    this.attendanceId,
    this.student,
    this.category,
    this.scannedAt,
  });

  factory ScanResultData.fromJson(Map<String, dynamic> json) =>
      _$ScanResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResultDataToJson(this);
}

/// Student info from scan
@JsonSerializable()
class StudentInfo {
  final int id;
  final String name;
  final String nisn;
  final String? nis;
  @JsonKey(name: 'class_name')
  final String? className;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  const StudentInfo({
    required this.id,
    required this.name,
    required this.nisn,
    this.nis,
    this.className,
    this.photoUrl,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) =>
      _$StudentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StudentInfoToJson(this);
}

/// Scan history item for display
@JsonSerializable()
class ScanHistoryItem {
  final StudentInfo student;
  final String category;
  @JsonKey(name: 'scanned_at')
  final String scannedAt;

  const ScanHistoryItem({
    required this.student,
    required this.category,
    required this.scannedAt,
  });

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$ScanHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$ScanHistoryItemToJson(this);
}
