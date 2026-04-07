import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/user.dart';
import '../models/login_response.dart';

/// Auth Repository for handling authentication API calls
class AuthRepository {
  final DioClient _dioClient;
  final SecureStorageService _storage;

  AuthRepository({DioClient? dioClient, SecureStorageService? storage})
    : _dioClient = dioClient ?? DioClient(),
      _storage = storage ?? SecureStorageService();

  /// Login with NIP and password
  /// Returns LoginData containing user and token
  /// Throws ApiException on error
  Future<LoginData> login({
    required String nip,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {'nip': nip, 'password': password},
      );

      // Parse response
      final apiResponse = ApiResponse<LoginData>.fromJson(
        response.data,
        (json) => LoginData.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException(
          message: apiResponse.message,
          statusCode: response.statusCode ?? 0,
          type: ApiExceptionType.serverError,
        );
      }

      final loginData = apiResponse.data!;

      // Save token and user data to secure storage
      await _storage.saveAccessToken(loginData.token);
      await _storage.saveUserData(jsonEncode(loginData.user.toJson()));

      return loginData;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: ApiConstants.errorUnknown,
        statusCode: e.response?.statusCode ?? 0,
        type: ApiExceptionType.unknown,
      );
    }
  }

  /// Logout - revoke token and clear storage
  Future<void> logout() async {
    try {
      // Call logout API to revoke token
      await _dioClient.dio.post(ApiConstants.logout);
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      // Always clear local storage
      await _storage.clearSecureData();
    }
  }

  /// Get current user from storage
  Future<User?> getCurrentUser() async {
    try {
      final userDataString = await _storage.getUserData();
      if (userDataString == null || userDataString.isEmpty) {
        return null;
      }

      final userJson = jsonDecode(userDataString) as Map<String, dynamic>;
      return User.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  /// Get user profile from API (refresh user data)
  Future<User> getProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.me);

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ApiException(
          message: apiResponse.message,
          statusCode: response.statusCode ?? 0,
          type: ApiExceptionType.serverError,
        );
      }

      final user = apiResponse.data!;

      // Update user data in storage
      await _storage.saveUserData(jsonEncode(user.toJson()));

      return user;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: ApiConstants.errorUnknown,
        statusCode: e.response?.statusCode ?? 0,
        type: ApiExceptionType.unknown,
      );
    }
  }
}
