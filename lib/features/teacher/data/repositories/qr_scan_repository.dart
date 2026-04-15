import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/qr_scan.dart';

class QrScanRepository {
  final DioClient _dioClient;

  QrScanRepository({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// Get available attendance categories (activities)
  Future<List<ActivityGroup>> getCategories() async {
    try {
      final response = await _dioClient.dio.get('/attendance/categories');

      if (response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'] ?? [];

        return data.map((json) => ActivityGroup.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get categories');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal memuat kategori absensi',
      );
    }
  }

  /// Submit QR scan attendance
  Future<ScanResponse> submitScan({
    required String nisn,
    required String categoryId,
    String? notes,
  }) async {
    try {
      final data = <String, dynamic>{
        'qr_code': nisn,
        'type': categoryId,
        if (notes != null && notes.isNotEmpty) 'kegiatan': notes,
      };

      final response = await _dioClient.dio.post(
        '/attendance/scan',
        data: data,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic> &&
          responseData['status'] != 'success') {
        throw Exception(responseData['message'] ?? 'Gagal menyimpan absensi');
      }

      return ScanResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle specific error responses
      if (e.response?.statusCode == 404) {
        throw Exception('Siswa tidak ditemukan');
      } else if (e.response?.statusCode == 422) {
        throw Exception(e.response?.data['message'] ?? 'Data tidak valid');
      } else if (e.response?.statusCode == 409) {
        final data = e.response?.data;
        final payload = data is Map ? data['data'] : null;
        final status = payload is Map ? payload['permission_status'] : null;
        final note = payload is Map ? payload['permission_note'] : null;

        if (status != null) {
          final extra = (note != null && note.toString().trim().isNotEmpty)
              ? ' (${note.toString().trim()})'
              : '';
          throw Exception(
            'Siswa sedang $status dari wali kelas$extra, jadi tidak bisa discan sebagai hadir.',
          );
        }

        throw Exception(e.response?.data['message'] ?? 'Siswa sudah diabsen');
      }
      throw Exception(e.response?.data['message'] ?? 'Gagal menyimpan absensi');
    }
  }

  /// Get recent scan history (optional endpoint)
  Future<List<ScanHistoryItem>> getRecentScans({int limit = 10}) async {
    try {
      final response = await _dioClient.dio.get(
        '/attendance/recent',
        queryParameters: {'limit': limit},
      );

      if (response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ScanHistoryItem.fromJson(json)).toList();
      } else {
        return []; // Return empty list if endpoint not available
      }
    } on DioException {
      return []; // Silently return empty list
    }
  }
}
