// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };

ScheduleItem _$ScheduleItemFromJson(Map<String, dynamic> json) => ScheduleItem(
      id: (json['id'] as num).toInt(),
      statusJurnal: $enumDecode(_$JournalStatusEnumMap, json['status_jurnal']),
      subject: json['subject'] as String,
      className: json['className'] as String,
      timeSlot: TimeSlot.fromJson(json['time_slot'] as Map<String, dynamic>),
      keterangan: json['keterangan'] as String?,
      journalId: (json['journal_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScheduleItemToJson(ScheduleItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status_jurnal': _$JournalStatusEnumMap[instance.statusJurnal]!,
      'subject': instance.subject,
      'className': instance.className,
      'time_slot': instance.timeSlot,
      'keterangan': instance.keterangan,
      'journal_id': instance.journalId,
    };

const _$JournalStatusEnumMap = {
  JournalStatus.done: 'DONE',
  JournalStatus.open: 'OPEN',
  JournalStatus.locked: 'LOCKED',
};

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    ScheduleResponse(
      status: json['status'] as String,
      hariIni: json['hari_ini'] as String,
      tanggal: json['tanggal'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'hari_ini': instance.hariIni,
      'tanggal': instance.tanggal,
      'data': instance.data,
    };
