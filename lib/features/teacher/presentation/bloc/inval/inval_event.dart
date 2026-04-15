abstract class InvalEvent {
  const InvalEvent();
}

class LoadInvalClasses extends InvalEvent {
  const LoadInvalClasses();
}

class ClaimInvalClassEvent extends InvalEvent {
  final List<int> scheduleIds;
  const ClaimInvalClassEvent(this.scheduleIds);
}
