import 'package:equatable/equatable.dart';
import '../../../data/models/permission.dart';

abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object?> get props => [];
}

class PermissionInitial extends PermissionState {}

class PermissionLoading extends PermissionState {}

class PermissionActionLoading extends PermissionState {}

class PermissionStudentsLoading extends PermissionState {}

class PermissionLoaded extends PermissionState {
  final List<Permission> permissions;

  const PermissionLoaded(this.permissions);

  @override
  List<Object?> get props => [permissions];
}

class PermissionStudentsLoaded extends PermissionState {
  final List<StudentPermission> students;

  const PermissionStudentsLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

class PermissionSuccess extends PermissionState {
  final String message;

  const PermissionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PermissionError extends PermissionState {
  final String message;

  const PermissionError(this.message);

  @override
  List<Object?> get props => [message];
}
