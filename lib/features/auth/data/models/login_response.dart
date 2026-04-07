import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'login_response.g.dart';

/// API Response wrapper
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;

  const ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  @override
  List<Object?> get props => [success, message, data];
}

/// Login response data containing user and token
@JsonSerializable()
class LoginData extends Equatable {
  final User user;
  final String token;

  const LoginData({required this.user, required this.token});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);

  @override
  List<Object?> get props => [user, token];
}

/// Complete login response
typedef LoginResponse = ApiResponse<LoginData>;

/// Logout response (simple success message)
typedef LogoutResponse = ApiResponse<dynamic>;
