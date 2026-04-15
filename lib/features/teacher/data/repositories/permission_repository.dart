import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/permission.dart';

class PermissionRepository {
  final _dio = DioClient().dio;

  Future<List<Permission>> getPermissions() async {
    try {
      final response = await _dio.get('/permissions');

      if (response.data['status'] == 'success') {
        final List<dynamic> rawData = response.data['data'];
        return rawData.map((e) => Permission.fromJson(e)).toList();
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load permissions',
        );
      }
    } catch (e) {
      throw Exception('Gagal memuat daftar izin: $e');
    }
  }

  Future<List<StudentPermission>> getStudents() async {
    try {
      final response = await _dio.get('/permissions/students');

      if (response.data['status'] == 'success') {
        final List<dynamic> rawData = response.data['data'];
        return rawData.map((e) => StudentPermission.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load students');
      }
    } catch (e) {
      throw Exception('Gagal memuat daftar siswa: $e');
    }
  }

  Future<String> submitPermission(FormData data) async {
    try {
      final response = await _dio.post(
        '/permissions/store',
        data: data,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.data['status'] == 'success') {
        return response.data['message'] ?? 'Berhasil menambahkan izin';
      } else {
        throw Exception(response.data['message'] ?? 'Gagal menambahkan izin');
      }
    } catch (e) {
      throw Exception('Gagal menambahkan izin: $e');
    }
  }

  Future<String> approveByBk(int permissionId) async {
    try {
      final response = await _dio.post('/bk/permissions/$permissionId/approve');

      if (response.data['status'] == 'success') {
        return response.data['message'] ?? 'Pengajuan berhasil disetujui BK';
      }
      throw Exception(response.data['message'] ?? 'Gagal menyetujui pengajuan');
    } catch (e) {
      throw Exception('Gagal menyetujui pengajuan BK: $e');
    }
  }

  Future<String> rejectByBk(int permissionId) async {
    try {
      final response = await _dio.post('/bk/permissions/$permissionId/reject');

      if (response.data['status'] == 'success') {
        return response.data['message'] ?? 'Pengajuan berhasil ditolak BK';
      }
      throw Exception(response.data['message'] ?? 'Gagal menolak pengajuan');
    } catch (e) {
      throw Exception('Gagal menolak pengajuan BK: $e');
    }
  }
}
