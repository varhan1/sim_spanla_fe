import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/journal_repository.dart';
import 'journal_history_event.dart';
import 'journal_history_state.dart';

class JournalHistoryBloc
    extends Bloc<JournalHistoryEvent, JournalHistoryState> {
  final JournalRepository _journalRepository;

  JournalHistoryBloc(this._journalRepository) : super(JournalHistoryInitial()) {
    on<FetchJournalHistory>(_onFetchJournalHistory);
  }

  Future<void> _onFetchJournalHistory(
    FetchJournalHistory event,
    Emitter<JournalHistoryState> emit,
  ) async {
    emit(JournalHistoryLoading());

    try {
      final response = await _journalRepository.getJournalHistory(
        event.journalId,
      );

      if (response.status == 'success' && response.data != null) {
        emit(JournalHistoryLoaded(response.data!));
      } else {
        emit(
          JournalHistoryError(
            response.message ?? 'Gagal memuat detail jurnal.',
          ),
        );
      }
    } catch (e) {
      emit(JournalHistoryError(e.toString()));
    }
  }
}
