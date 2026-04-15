part of 'qr_scan_bloc.dart';

abstract class QrScanEvent extends Equatable {
  const QrScanEvent();

  @override
  List<Object?> get props => [];
}

/// Load attendance categories
class LoadCategories extends QrScanEvent {
  const LoadCategories();
}

/// Select a category (scan type)
class SelectCategory extends QrScanEvent {
  final AttendanceCategory category;

  const SelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// Select an activity group
class SelectActivity extends QrScanEvent {
  final ActivityGroup activity;

  const SelectActivity(this.activity);

  @override
  List<Object?> get props => [activity];
}

/// Process QR code scan
class ProcessScan extends QrScanEvent {
  final String qrData;

  const ProcessScan(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

/// Submit scanned attendance
class SubmitScan extends QrScanEvent {
  final String nisn;
  final String? notes;

  const SubmitScan({required this.nisn, this.notes});

  @override
  List<Object?> get props => [nisn, notes];
}

/// Clear scan result to continue scanning
class ClearScanResult extends QrScanEvent {
  const ClearScanResult();
}

/// Toggle flashlight
class ToggleFlashlight extends QrScanEvent {
  const ToggleFlashlight();
}

/// Reset scanner state
class ResetScanner extends QrScanEvent {
  const ResetScanner();
}
