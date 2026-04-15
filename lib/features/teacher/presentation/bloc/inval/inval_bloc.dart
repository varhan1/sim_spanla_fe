import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/inval_repository.dart';
import 'inval_event.dart';
import 'inval_state.dart';

class InvalBloc extends Bloc<InvalEvent, InvalState> {
  final InvalRepository repository;

  InvalBloc({required this.repository}) : super(InvalInitial()) {
    on<LoadInvalClasses>(_onLoadInvalClasses);
    on<ClaimInvalClassEvent>(_onClaimInvalClass);
  }

  Future<void> _onLoadInvalClasses(
    LoadInvalClasses event,
    Emitter<InvalState> emit,
  ) async {
    emit(InvalLoading());
    try {
      final classes = await repository.getAvailableInvalClasses();
      final history = await repository.getInvalHistory();
      emit(InvalLoaded(classes, history: history));
    } catch (e) {
      emit(InvalError(e.toString()));
    }
  }

  Future<void> _onClaimInvalClass(
    ClaimInvalClassEvent event,
    Emitter<InvalState> emit,
  ) async {
    try {
      final message = await repository.claimInvalClass(event.scheduleIds);
      emit(InvalClaimSuccess(message));
      // Reload the data after a successful claim
      add(const LoadInvalClasses());
    } catch (e) {
      emit(InvalClaimError(e.toString()));
      // Restore the loaded state so the UI doesn't break
      add(const LoadInvalClasses());
    }
  }
}
