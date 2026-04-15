class GradeMeta {
  final String classId;
  final int? activePeriodId;
  final List<GradePeriod> periods;
  final List<GradeSubject> subjects;
  final List<GradeCategory> categories;

  const GradeMeta({
    required this.classId,
    required this.activePeriodId,
    required this.periods,
    required this.subjects,
    required this.categories,
  });

  factory GradeMeta.fromJson(Map<String, dynamic> json) {
    final periodActive = json['period_active'];
    return GradeMeta(
      classId: json['class_id']?.toString() ?? '-',
      activePeriodId: periodActive is Map
          ? int.tryParse(periodActive['id']?.toString() ?? '')
          : null,
      periods: (json['periods'] as List<dynamic>? ?? [])
          .map((e) => GradePeriod.fromJson(e as Map<String, dynamic>))
          .toList(),
      subjects: (json['subjects'] as List<dynamic>? ?? [])
          .map((e) => GradeSubject.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((e) => GradeCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GradePeriod {
  final int id;
  final String name;

  const GradePeriod({required this.id, required this.name});

  factory GradePeriod.fromJson(Map<String, dynamic> json) {
    return GradePeriod(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '-',
    );
  }
}

class GradeSubject {
  final int id;
  final String name;

  const GradeSubject({required this.id, required this.name});

  factory GradeSubject.fromJson(Map<String, dynamic> json) {
    return GradeSubject(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '-',
    );
  }
}

class GradeCategory {
  final int id;
  final String name;
  final bool isRepeatable;
  final int maxItem;
  final double maxScore;

  const GradeCategory({
    required this.id,
    required this.name,
    required this.isRepeatable,
    required this.maxItem,
    required this.maxScore,
  });

  factory GradeCategory.fromJson(Map<String, dynamic> json) {
    return GradeCategory(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '-',
      isRepeatable: json['is_repeatable'] == true,
      maxItem: int.tryParse(json['max_item']?.toString() ?? '1') ?? 1,
      maxScore: double.tryParse(json['max_score']?.toString() ?? '100') ?? 100,
    );
  }
}

class GradeStudent {
  final int id;
  final String name;
  final String? nis;

  const GradeStudent({required this.id, required this.name, this.nis});

  factory GradeStudent.fromJson(Map<String, dynamic> json) {
    return GradeStudent(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '-',
      nis: json['nis']?.toString(),
    );
  }
}

class GradeScore {
  final int studentId;
  final double score;
  final String? notes;

  const GradeScore({required this.studentId, required this.score, this.notes});

  factory GradeScore.fromJson(Map<String, dynamic> json) {
    return GradeScore(
      studentId: int.tryParse(json['student_id']?.toString() ?? '0') ?? 0,
      score: double.tryParse(json['score']?.toString() ?? '0') ?? 0,
      notes: json['notes']?.toString(),
    );
  }
}

class GradeSummary {
  final int totalStudents;
  final int completed;
  final int pending;
  final double average;
  final double topScore;
  final double passRate;
  final String? lastSyncedAt;
  final bool isLocked;

  const GradeSummary({
    required this.totalStudents,
    required this.completed,
    required this.pending,
    required this.average,
    required this.topScore,
    required this.passRate,
    required this.lastSyncedAt,
    required this.isLocked,
  });

  factory GradeSummary.fromJson(Map<String, dynamic> json) {
    return GradeSummary(
      totalStudents:
          int.tryParse(json['total_students']?.toString() ?? '0') ?? 0,
      completed: int.tryParse(json['completed']?.toString() ?? '0') ?? 0,
      pending: int.tryParse(json['pending']?.toString() ?? '0') ?? 0,
      average: double.tryParse(json['average']?.toString() ?? '0') ?? 0,
      topScore: double.tryParse(json['top_score']?.toString() ?? '0') ?? 0,
      passRate: double.tryParse(json['pass_rate']?.toString() ?? '0') ?? 0,
      lastSyncedAt: json['last_synced_at']?.toString(),
      isLocked: json['is_locked'] == true,
    );
  }
}
