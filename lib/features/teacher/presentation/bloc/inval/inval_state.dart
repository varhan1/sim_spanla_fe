import '../../../data/models/inval_class.dart';
import '../../../data/models/inval_history_item.dart';

abstract class InvalState {
  const InvalState();
}

class InvalInitial extends InvalState {}

class InvalLoading extends InvalState {}

class InvalLoaded extends InvalState {
  final List<InvalClass> classes;
  final List<InvalHistoryItem> history;

  const InvalLoaded(this.classes, {this.history = const []});
}

class InvalError extends InvalState {
  final String message;
  const InvalError(this.message);
}

class InvalClaimSuccess extends InvalState {
  final String message;
  const InvalClaimSuccess(this.message);
}

class InvalClaimError extends InvalState {
  final String message;
  const InvalClaimError(this.message);
}
