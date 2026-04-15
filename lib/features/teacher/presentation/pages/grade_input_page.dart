import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/models/grade_models.dart';
import '../../data/repositories/grade_repository.dart';

class GradeInputPage extends StatefulWidget {
  final GradePeriod period;
  final GradeSubject subject;
  final GradeCategory category;
  final int itemNo;
  final String classId;

  const GradeInputPage({
    super.key,
    required this.period,
    required this.subject,
    required this.category,
    required this.itemNo,
    required this.classId,
  });

  @override
  State<GradeInputPage> createState() => _GradeInputPageState();
}

class _GradeInputPageState extends State<GradeInputPage> {
  final GradeRepository _repository = GradeRepository();
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, double> _scores = {};
  final Map<int, String> _syncStatus = {};

  List<GradeStudent> _students = const [];
  bool _loading = true;
  bool _locked = false;
  String _query = '';
  Timer? _debounce;
  DateTime? _lastSyncedAt;
  GradeSummary? _summary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final students = await _repository.getStudents();
      final scores = await _repository.getScores(
        periodId: widget.period.id,
        subjectId: widget.subject.id,
        categoryId: widget.category.id,
        itemNo: widget.itemNo,
      );
      final summary = await _repository.getSummary(
        periodId: widget.period.id,
        subjectId: widget.subject.id,
        categoryId: widget.category.id,
        itemNo: widget.itemNo,
      );

      final map = {for (final s in scores) s.studentId: s};
      for (final s in students) {
        final value = map[s.id]?.score;
        _scores[s.id] = value ?? 0;
        _syncStatus[s.id] = 'tersimpan';
        _controllers[s.id] = TextEditingController(
          text: value == null ? '' : value.toStringAsFixed(0),
        );
      }

      if (!mounted) return;
      setState(() {
        _students = students;
        _summary = summary;
        _locked = summary.isLocked;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  Future<void> _refreshSummary() async {
    final summary = await _repository.getSummary(
      periodId: widget.period.id,
      subjectId: widget.subject.id,
      categoryId: widget.category.id,
      itemNo: widget.itemNo,
    );
    if (!mounted) return;
    setState(() {
      _summary = summary;
      _locked = summary.isLocked;
    });
  }

  void _onChanged(int studentId, String value) {
    if (_locked) return;

    if (value.trim().isEmpty) {
      _scores[studentId] = 0;
      _syncStatus[studentId] = 'menyimpan';
      setState(() {});
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 900), _flushPending);
      return;
    }

    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) return;

    final max = widget.category.maxScore;
    final sanitized = parsed > max ? max : parsed;
    _scores[studentId] = sanitized;
    if (sanitized != parsed) {
      _controllers[studentId]?.text = sanitized.toStringAsFixed(0);
      _controllers[studentId]?.selection = TextSelection.fromPosition(
        TextPosition(offset: _controllers[studentId]!.text.length),
      );
    }

    _syncStatus[studentId] = 'menyimpan';
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 900), _flushPending);
  }

  Future<void> _flushPending() async {
    if (_locked) return;

    final pending = _syncStatus.entries
        .where((e) => e.value == 'menyimpan')
        .map((e) => e.key)
        .toList();
    if (pending.isEmpty) return;

    final entries = pending
        .map(
          (studentId) => {
            'student_id': studentId,
            'category_id': widget.category.id,
            'item_no': widget.itemNo,
            'score': _scores[studentId] ?? 0,
            'notes': null,
          },
        )
        .toList();

    try {
      await _repository.bulkUpsert(
        periodId: widget.period.id,
        subjectId: widget.subject.id,
        entries: entries,
      );
      for (final id in pending) {
        _syncStatus[id] = 'tersimpan';
      }
      _lastSyncedAt = DateTime.now();
      await _refreshSummary();
      if (mounted) setState(() {});
    } catch (_) {
      for (final id in pending) {
        _syncStatus[id] = 'gagal';
      }
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final summary = _summary;
    final total = summary?.totalStudents ?? _students.length;
    final completed = summary?.completed ?? 0;
    final pending = summary?.pending ?? (total - completed);
    final filtered = _students.where((s) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return s.name.toLowerCase().contains(q) ||
          (s.nis ?? '').toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF121826)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Input Penilaian',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF121826),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari nama siswa atau NIS...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFE9EDFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Row(
                  children: [
                    Text(
                      'Daftar Siswa',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.period.name.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8A93A8),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...filtered.map((student) {
                  final txt = _controllers[student.id]?.text.trim() ?? '';
                  final hasValue = txt.isNotEmpty;
                  final scoreValue = double.tryParse(txt.replaceAll(',', '.'));
                  final lowScore = hasValue && (scoreValue ?? 0) < 60;
                  final status = _syncStatus[student.id] ?? '-';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: lowScore
                          ? Border.all(
                              color: const Color(0xFFFF9B9B),
                              width: 1.4,
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFE2E8F5),
                          child: Text(
                            student.name
                                .split(' ')
                                .take(2)
                                .map((e) => e[0])
                                .join()
                                .toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2B4CC8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'NIS ${student.nis ?? '-'}',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF99A0B3),
                                  fontSize: 12,
                                ),
                              ),
                              if (lowScore)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEEEE),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'PERLU PERHATIAN',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFCC3F3F),
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: _controllers[student.id],
                            enabled: !_locked,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              color: lowScore
                                  ? const Color(0xFFCC3F3F)
                                  : const Color(0xFF2B4CC8),
                            ),
                            decoration: InputDecoration(
                              hintText: '--',
                              filled: true,
                              fillColor: const Color(0xFFEFF2FF),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (v) => _onChanged(student.id, v),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          status == 'gagal'
                              ? Icons.sync_problem_rounded
                              : status == 'menyimpan'
                              ? Icons.sync_rounded
                              : Icons.check_circle_rounded,
                          color: status == 'gagal'
                              ? const Color(0xFFB91C1C)
                              : const Color(0xFF22C55E),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 170),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$completed dari $total Terskor',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pending == 0
                              ? 'Semua nilai sudah terisi'
                              : '$pending siswa belum diisi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                            color: pending == 0
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFCC3F3F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: total == 0 ? 0 : completed / total,
                      borderRadius: BorderRadius.circular(999),
                      color: const Color(0xFF2B4CC8),
                      backgroundColor: const Color(0xFFE6EBFA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _locked
                      ? null
                      : () async {
                          await _flushPending();
                          await _refreshSummary();
                          if (!mounted) return;
                          _showFinalizationScreen();
                        },
                  icon: const Icon(Icons.rocket_launch_rounded),
                  label: const Text('Review & Publish'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2250E8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              if (_lastSyncedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Tersinkron ${DateFormat('HH:mm').format(_lastSyncedAt!)}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF8A93A8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFinalizationScreen() {
    final s = _summary;
    if (s == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8EEFF),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF2250E8),
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ringkasan Entri',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 33,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.pending == 0
                        ? 'Semua nilai siswa telah berhasil diproses.'
                        : 'Masih ada nilai yang belum terisi.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: const Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.45,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _summaryCard('TOTAL SISWA', '${s.totalStudents}'),
                      _summaryCard('SELESAI', '${s.completed}'),
                      _summaryCard('PENDING', '${s.pending}'),
                      _summaryCard(
                        'SINKRON TERAKHIR',
                        s.lastSyncedAt == null
                            ? '-'
                            : DateFormat('HH:mm').format(
                                DateTime.parse(s.lastSyncedAt!).toLocal(),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: s.pending > 0
                          ? null
                          : () async {
                              try {
                                await _repository.finishAndLock(
                                  periodId: widget.period.id,
                                  subjectId: widget.subject.id,
                                  categoryId: widget.category.id,
                                  itemNo: widget.itemNo,
                                );
                                if (!mounted) return;
                                Navigator.of(context).pop();
                                await _refreshSummary();
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Nilai berhasil dikunci.'),
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            },
                      icon: const Icon(Icons.lock_rounded),
                      label: const Text('Finish & Lock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2250E8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('Continue Editing'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F4FF),
                        foregroundColor: const Color(0xFF2250E8),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analitik Kelas',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _metric(
                                'Persentase Lulus',
                                '${s.passRate.toStringAsFixed(0)}%',
                              ),
                            ),
                            Expanded(
                              child: _metric(
                                'Rata-rata Nilai',
                                _toGradeLabel(s.average),
                              ),
                            ),
                            Expanded(
                              child: _metric(
                                'Nilai Tertinggi',
                                s.topScore.toStringAsFixed(0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _summaryCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: const Color(0xFF5B67A7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF7A8199),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _toGradeLabel(double average) {
    if (average >= 90) return 'A';
    if (average >= 80) return 'B+';
    if (average >= 70) return 'B';
    if (average >= 60) return 'C';
    return 'D';
  }
}
