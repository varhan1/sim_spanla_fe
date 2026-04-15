import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object?> get props => [];
}

class LoadPermissions extends PermissionEvent {}

class LoadStudents extends PermissionEvent {}

class SubmitPermission extends PermissionEvent {
  final int studentId;
  final String type;
  final String startDate;
  final String endDate;
  final String keterangan;
  final File? foto;

  const SubmitPermission({
    required this.studentId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.keterangan,
    this.foto,
  });

  @override
  List<Object?> get props => [
    studentId,
    type,
    startDate,
    endDate,
    keterangan,
    foto,
  ];
}

class ApprovePermissionByBk extends PermissionEvent {
  final int permissionId;

  const ApprovePermissionByBk(this.permissionId);

  @override
  List<Object?> get props => [permissionId];
}

class RejectPermissionByBk extends PermissionEvent {
  final int permissionId;

  const RejectPermissionByBk(this.permissionId);

  @override
  List<Object?> get props => [permissionId];
}
