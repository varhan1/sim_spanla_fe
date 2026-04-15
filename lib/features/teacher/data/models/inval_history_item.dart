class InvalHistoryItem {
  final int id;
  final int scheduleId;
  final String subject;
  final String className;
  final String time;
  final String claimedByNip;
  final String claimedByName;
  final String status;
  final String? claimedAt;

  const InvalHistoryItem({
    required this.id,
    required this.scheduleId,
    required this.subject,
    required this.className,
    required this.time,
    required this.claimedByNip,
    required this.claimedByName,
    required this.status,
    this.claimedAt,
  });

  factory InvalHistoryItem.fromJson(Map<String, dynamic> json) {
    return InvalHistoryItem(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      scheduleId: int.tryParse(json['schedule_id']?.toString() ?? '0') ?? 0,
      subject: json['subject']?.toString() ?? '-',
      className: (json['className'] ?? json['class_name'])?.toString() ?? '-',
      time: json['time']?.toString() ?? '-',
      claimedByNip:
          (json['claimed_by_nip'] ?? json['replacement_teacher_id'])
              ?.toString() ??
          '-',
      claimedByName:
          (json['claimed_by_name'] ?? json['replacement_teacher_name'])
              ?.toString() ??
          '-',
      status: json['status']?.toString() ?? '-',
      claimedAt: json['claimed_at']?.toString(),
    );
  }
}
