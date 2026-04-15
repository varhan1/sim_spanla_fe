import 'package:equatable/equatable.dart';

abstract class JournalHistoryEvent extends Equatable {
  const JournalHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchJournalHistory extends JournalHistoryEvent {
  final int journalId;

  const FetchJournalHistory(this.journalId);

  @override
  List<Object?> get props => [journalId];
}
