import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/journal_history.dart';
import '../../data/repositories/journal_repository.dart';

class JournalHistoryDetailPage extends StatefulWidget {
  final int journalId;
  final String subjectName;
  final String className;
  final String date;
  final String timeSlot;

  const JournalHistoryDetailPage({
    super.key,
    required this.journalId,
    required this.subjectName,
    required this.className,
    required this.date,
    required this.timeSlot,
  });

  @override
  State<JournalHistoryDetailPage> createState() =>
      _JournalHistoryDetailPageState();
}

class _JournalHistoryDetailPageState extends State<JournalHistoryDetailPage> {
  static const Color _surface = Color(0xFFFAF8FF);
  static const Color _primary = Color(0xFF0040DF);
  static const Color _primaryContainer = Color(0xFF2D5BFF);
  static const Color _onSurface = Color(0xFF131B2E);
  static const Color _onSurfaceVariant = Color(0xFF434655);
  static const Color _surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color _surfaceContainerHighest = Color(0xFFDAE2FD);
  static const Color _surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color _surfaceContainerHigh = Color(0xFFE2E7FF);

  final _repository = JournalRepository();
  bool _isLoading = true;
  String? _error;
  JournalHistoryData? _detail;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _repository.getJournalHistory(widget.journalId);
      if (!mounted) return;

      if (response.status == 'success' && response.data != null) {
        setState(() {
          _detail = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? 'Data riwayat jurnal tidak tersedia';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: _primary))
          else if (_error != null)
            _buildErrorState()
          else
            SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 70,
                bottom: 120,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroHeader(),
                    const SizedBox(height: 24),
                    _buildSummaryCards(),
                    const SizedBox(height: 24),
                    _buildAttendanceList(),
                  ],
                ),
              ),
            ),
          _buildTopAppBar(),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: MediaQuery.of(context).padding.top + 60,
            padding: EdgeInsets.fromLTRB(
              24,
              MediaQuery.of(context).padding.top,
              24,
              0,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(179),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF131B2E).withAlpha(15),
                  blurRadius: 40,
                ),
              ],
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _surfaceContainerHigh,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: _onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Detail Jurnal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    final detail = _detail!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primary, _primaryContainer],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _primary.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DETAIL JURNAL',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white.withAlpha(204),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail.subject,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.school, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'Kelas ${detail.className}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withAlpha(230),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildHeroChip(
                Icons.calendar_today,
                _formatCreatedAt(detail.createdAt),
              ),
              _buildHeroChip(
                Icons.access_time,
                '${detail.timeSlot.startTime} - ${detail.timeSlot.endTime}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withAlpha(25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final detail = _detail!;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book, color: _primary, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'Materi Pelajaran',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                detail.material.isEmpty ? '-' : detail.material,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.6,
                  color: _onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.cleaning_services, color: _primary, size: 20),
              const SizedBox(width: 12),
              Text(
                'Kebersihan Kelas',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _onSurface,
                ),
              ),
              const Spacer(),
              _buildCleanlinessBadge(detail.cleanliness),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCleanlinessBadge(String? cleanliness) {
    final raw = (cleanliness ?? '').trim().toLowerCase();
    final label = raw == 'sudah_bersih'
        ? 'Bersih'
        : raw == 'kotor'
        ? 'Kurang Bersih'
        : (cleanliness == null || cleanliness.isEmpty)
        ? '-'
        : cleanliness;

    final isClean = raw == 'sudah_bersih' || raw == 'bersih';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isClean ? const Color(0xFFDFF5E6) : const Color(0xFFFFE5E1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isClean ? const Color(0xFF1B7A3A) : const Color(0xFFB3261E),
        ),
      ),
    );
  }

  Widget _buildAttendanceList() {
    final detail = _detail!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.group, color: _primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Kehadiran Siswa',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (detail.absensi.isEmpty)
            Text(
              'Belum ada data kehadiran siswa.',
              style: GoogleFonts.inter(fontSize: 14, color: _onSurfaceVariant),
            )
          else
            ...detail.absensi.map(_buildStudentItem),
        ],
      ),
    );
  }

  Widget _buildStudentItem(JournalHistoryAbsensi item) {
    final statusLabel = _statusLabel(item.status);
    final statusColor = _statusColor(item.status);

    final initials = item.studentName
        .split(' ')
        .where((e) => e.trim().isNotEmpty)
        .take(2)
        .map((e) => e[0].toUpperCase())
        .join();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: _surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials.isEmpty ? 'S' : initials,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: _primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.studentName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: _onSurface,
                  ),
                ),
                Text(
                  'NIS: ${item.nis ?? '-'}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(26),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              statusLabel,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 44),
            const SizedBox(height: 12),
            Text(
              _error ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: _onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadDetail,
              child: const Text('Muat ulang'),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    final s = status.toLowerCase();
    if (s.contains('hadir')) return 'HADIR';
    if (s.contains('sakit')) return 'SAKIT';
    if (s.contains('izin')) return 'IZIN';
    if (s.contains('alpa')) return 'ALPA';
    return status.toUpperCase();
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('hadir')) return const Color(0xFF1B7A3A);
    if (s.contains('sakit')) return const Color(0xFFB26A00);
    if (s.contains('izin')) return const Color(0xFF0B66D0);
    if (s.contains('alpa')) return const Color(0xFFB3261E);
    return _onSurfaceVariant;
  }

  String _formatCreatedAt(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return widget.date;

    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}
