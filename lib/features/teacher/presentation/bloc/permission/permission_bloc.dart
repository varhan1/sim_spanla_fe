import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../data/repositories/permission_repository.dart';
import 'permission_event.dart';
import 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final PermissionRepository repository;

  PermissionBloc({required this.repository}) : super(PermissionInitial()) {
    on<LoadPermissions>(_onLoadPermissions);
    on<LoadStudents>(_onLoadStudents);
    on<SubmitPermission>(_onSubmitPermission);
    on<ApprovePermissionByBk>(_onApprovePermissionByBk);
    on<RejectPermissionByBk>(_onRejectPermissionByBk);
  }

  Future<void> _onLoadPermissions(
    LoadPermissions event,
    Emitter<PermissionState> emit,
  ) async {
    emit(PermissionLoading());
    try {
      final permissions = await repository.getPermissions();
      emit(PermissionLoaded(permissions));
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }

  Future<void> _onLoadStudents(
    LoadStudents event,
    Emitter<PermissionState> emit,
  ) async {
    emit(PermissionStudentsLoading());
    try {
      final students = await repository.getStudents();
      emit(PermissionStudentsLoaded(students));
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }

  Future<void> _onSubmitPermission(
    SubmitPermission event,
    Emitter<PermissionState> emit,
  ) async {
    emit(PermissionLoading());
    try {
      final formData = FormData.fromMap({
        'student_id': event.studentId,
        'type': event.type,
        'start_date': event.startDate,
        'end_date': event.endDate,
        'keterangan': event.keterangan,
        if (event.foto != null)
          'foto': await MultipartFile.fromFile(
            event.foto!.path,
            filename: event.foto!.path.split('/').last,
          ),
      });

      final message = await repository.submitPermission(formData);
      emit(PermissionSuccess(message));
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }

  Future<void> _onApprovePermissionByBk(
    ApprovePermissionByBk event,
    Emitter<PermissionState> emit,
  ) async {
    emit(PermissionLoading());
    try {
      await repository.approveByBk(event.permissionId);
      final permissions = await repository.getPermissions();
      emit(PermissionLoaded(permissions));
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }

  Future<void> _onRejectPermissionByBk(
    RejectPermissionByBk event,
    Emitter<PermissionState> emit,
  ) async {
    emit(PermissionLoading());
    try {
      await repository.rejectByBk(event.permissionId);
      final permissions = await repository.getPermissions();
      emit(PermissionLoaded(permissions));
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }
}
