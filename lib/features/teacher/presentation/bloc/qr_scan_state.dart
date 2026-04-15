part of 'qr_scan_bloc.dart';

abstract class QrScanState extends Equatable {
  const QrScanState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class QrScanInitial extends QrScanState {
  const QrScanInitial();
}

/// Loading categories
class QrScanCategoriesLoading extends QrScanState {
  const QrScanCategoriesLoading();
}

/// Categories loaded, ready to scan
class QrScanReady extends QrScanState {
  final List<ActivityGroup> activities;
  final ActivityGroup? selectedActivity;
  final AttendanceCategory? selectedCategory;
  final bool flashlightOn;
  final List<ScanHistoryItem> recentScans;

  const QrScanReady({
    required this.activities,
    this.selectedActivity,
    this.selectedCategory,
    this.flashlightOn = false,
    this.recentScans = const [],
  });

  QrScanReady copyWith({
    List<ActivityGroup>? activities,
    ActivityGroup? selectedActivity,
    AttendanceCategory? selectedCategory,
    bool? flashlightOn,
    List<ScanHistoryItem>? recentScans,
  }) {
    return QrScanReady(
      activities: activities ?? this.activities,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      flashlightOn: flashlightOn ?? this.flashlightOn,
      recentScans: recentScans ?? this.recentScans,
    );
  }

  @override
  List<Object?> get props => [
    activities,
    selectedActivity,
    selectedCategory,
    flashlightOn,
    recentScans,
  ];
}

/// Processing QR code
class QrScanProcessing extends QrScanState {
  final String qrData;
  final List<ActivityGroup> activities;
  final ActivityGroup? selectedActivity;
  final AttendanceCategory? selectedCategory;
  final List<ScanHistoryItem> recentScans;

  const QrScanProcessing({
    required this.qrData,
    required this.activities,
    this.selectedActivity,
    this.selectedCategory,
    this.recentScans = const [],
  });

  @override
  List<Object?> get props => [
    qrData,
    activities,
    selectedActivity,
    selectedCategory,
    recentScans,
  ];
}

/// Scan success
class QrScanSuccess extends QrScanState {
  final ScanResponse response;
  final List<ActivityGroup> activities;
  final ActivityGroup? selectedActivity;
  final AttendanceCategory? selectedCategory;
  final List<ScanHistoryItem> recentScans;

  const QrScanSuccess({
    required this.response,
    required this.activities,
    this.selectedActivity,
    this.selectedCategory,
    this.recentScans = const [],
  });

  @override
  List<Object?> get props => [
    response,
    activities,
    selectedActivity,
    selectedCategory,
    recentScans,
  ];
}

/// Scan error
class QrScanError extends QrScanState {
  final String message;
  final List<ActivityGroup> activities;
  final ActivityGroup? selectedActivity;
  final AttendanceCategory? selectedCategory;
  final List<ScanHistoryItem> recentScans;

  const QrScanError({
    required this.message,
    required this.activities,
    this.selectedActivity,
    this.selectedCategory,
    this.recentScans = const [],
  });

  @override
  List<Object?> get props => [
    message,
    activities,
    selectedActivity,
    selectedCategory,
    recentScans,
  ];
}

/// Categories load error
class QrScanCategoriesError extends QrScanState {
  final String message;

  const QrScanCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
