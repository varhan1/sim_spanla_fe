class Permission {
  final int id;
  final StudentPermission student;
  final String type;
  final String? startDate;
  final String? endDate;
  final int totalHari;
  final String? keterangan;
  final String? fotoUrl;
  final String status;
  final String createdAt;

  Permission({
    required this.id,
    required this.student,
    required this.type,
    this.startDate,
    this.endDate,
    required this.totalHari,
    this.keterangan,
    this.fotoUrl,
    required this.status,
    required this.createdAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] ?? 0,
      student: StudentPermission.fromJson(json['student'] ?? {}),
      type: json['type'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalHari: json['total_hari'] ?? 0,
      keterangan: json['keterangan'],
      fotoUrl: json['foto_url'],
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  String get normalizedStatus => status.trim().toLowerCase();

  bool get isSubmittedToBk => {
    'pending',
    'pending_bk',
    'submitted',
    'menunggu',
  }.contains(normalizedStatus);

  bool get isVerifiedByBk =>
      {'verified_bk', 'pending_wali'}.contains(normalizedStatus);

  bool get isApprovedFinal => normalizedStatus == 'approved';

  bool get isRejected =>
      {'rejected', 'rejected_bk', 'rejected_wali'}.contains(normalizedStatus);
}

class StudentPermission {
  final int id;
  final String name;
  final String nis;
  final String classId;

  StudentPermission({
    required this.id,
    required this.name,
    required this.nis,
    required this.classId,
  });

  factory StudentPermission.fromJson(Map<String, dynamic> json) {
    int parsedId = 0;
    if (json['id'] != null) {
      parsedId = json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0;
    }

    return StudentPermission(
      id: parsedId,
      name: json['name']?.toString() ?? '',
      nis: json['nis']?.toString() ?? '',
      classId: json['class_id']?.toString() ?? '',
    );
  }
}
