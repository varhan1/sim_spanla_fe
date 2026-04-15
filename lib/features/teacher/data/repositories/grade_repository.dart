import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/grade_models.dart';

class GradeRepository {
  final _dio = DioClient().dio;

  Future<GradeMeta> getMeta() async {
    final response = await _dio.get(ApiConstants.gradesMeta);
    if (response.data['status'] != 'success') {
      throw Exception(
        response.data['message'] ?? 'Gagal memuat meta penilaian',
      );
    }
    return GradeMeta.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<GradeStudent>> getStudents() async {
    final response = await _dio.get(ApiConstants.gradesStudents);
    if (response.data['status'] != 'success') {
      throw Exception(response.data['message'] ?? 'Gagal memuat siswa');
    }

    final raw = response.data['data']?['students'] as List<dynamic>? ?? [];
    return raw
        .map((e) => GradeStudent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<GradeScore>> getScores({
    required int periodId,
    required int subjectId,
    required int categoryId,
    required int itemNo,
  }) async {
    final response = await _dio.get(
      ApiConstants.gradesScores,
      queryParameters: {
        'period_id': periodId,
        'subject_id': subjectId,
        'category_id': categoryId,
        'item_no': itemNo,
      },
    );

    if (response.data['status'] != 'success') {
      throw Exception(response.data['message'] ?? 'Gagal memuat nilai');
    }

    final raw = response.data['data']?['scores'] as List<dynamic>? ?? [];
    return raw
        .map((e) => GradeScore.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> bulkUpsert({
    required int periodId,
    required int subjectId,
    required List<Map<String, dynamic>> entries,
  }) async {
    final response = await _dio.post(
      ApiConstants.gradesBulkUpsert,
      data: {
        'period_id': periodId,
        'subject_id': subjectId,
        'entries': entries,
      },
    );

    if (response.data['status'] != 'success') {
      throw Exception(response.data['message'] ?? 'Gagal menyimpan nilai');
    }
  }

  Future<GradeSummary> getSummary({
    required int periodId,
    required int subjectId,
    required int categoryId,
    required int itemNo,
  }) async {
    final response = await _dio.get(
      ApiConstants.gradesSummary,
      queryParameters: {
        'period_id': periodId,
        'subject_id': subjectId,
        'category_id': categoryId,
        'item_no': itemNo,
      },
    );

    if (response.data['status'] != 'success') {
      throw Exception(
        response.data['message'] ?? 'Gagal memuat ringkasan nilai',
      );
    }

    return GradeSummary.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> finishAndLock({
    required int periodId,
    required int subjectId,
    required int categoryId,
    required int itemNo,
  }) async {
    final response = await _dio.post(
      ApiConstants.gradesFinishLock,
      data: {
        'period_id': periodId,
        'subject_id': subjectId,
        'category_id': categoryId,
        'item_no': itemNo,
      },
    );

    if (response.data['status'] != 'success') {
      throw Exception(response.data['message'] ?? 'Gagal mengunci input nilai');
    }
  }
}
