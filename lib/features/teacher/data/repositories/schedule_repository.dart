import '../../../../core/network/dio_client.dart';
import '../models/schedule.dart';

class ScheduleRepository {
  final DioClient _dioClient;

  ScheduleRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// Fetch teacher's schedules for a specific date
  /// [date] format: 'yyyy-MM-dd', defaults to today if null
  Future<ScheduleResponse> getSchedules({String? date}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null) {
        queryParams['date'] = date;
      }

      final response = await _dioClient.get(
        '/teacher/schedules',
        queryParameters: queryParams,
      );

      return ScheduleResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal memuat jadwal: ${e.toString()}');
    }
  }
}
