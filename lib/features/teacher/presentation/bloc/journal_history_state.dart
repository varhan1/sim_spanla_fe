import 'package:equatable/equatable.dart';
import '../../data/models/journal_history.dart';

abstract class JournalHistoryState extends Equatable {
  const JournalHistoryState();

  @override
  List<Object?> get props => [];
}

class JournalHistoryInitial extends JournalHistoryState {}

class JournalHistoryLoading extends JournalHistoryState {}

class JournalHistoryLoaded extends JournalHistoryState {
  final JournalHistoryData data;

  const JournalHistoryLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class JournalHistoryError extends JournalHistoryState {
  final String message;

  const JournalHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
