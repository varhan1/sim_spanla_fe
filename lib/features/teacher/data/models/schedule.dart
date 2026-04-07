import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

/// Enum for journal status
enum JournalStatus {
  @JsonValue('DONE')
  done,
  @JsonValue('OPEN')
  open,
  @JsonValue('LOCKED')
  locked,
}

/// Time slot model
@JsonSerializable()
class TimeSlot {
  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  TimeSlot({required this.startTime, required this.endTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}

/// Schedule item model from API
@JsonSerializable()
class ScheduleItem {
  final int id;

  @JsonKey(name: 'status_jurnal')
  final JournalStatus statusJurnal;

  final String subject;

  final String className;

  @JsonKey(name: 'time_slot')
  final TimeSlot timeSlot;

  final String? keterangan;

  @JsonKey(name: 'journal_id')
  final int? journalId;

  ScheduleItem({
    required this.id,
    required this.statusJurnal,
    required this.subject,
    required this.className,
    required this.timeSlot,
    this.keterangan,
    this.journalId,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleItemToJson(this);
}

/// API Response wrapper for schedules
@JsonSerializable()
class ScheduleResponse {
  final String status;

  @JsonKey(name: 'hari_ini')
  final String hariIni;

  final String tanggal;

  final List<ScheduleItem> data;

  ScheduleResponse({
    required this.status,
    required this.hariIni,
    required this.tanggal,
    required this.data,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);
}
