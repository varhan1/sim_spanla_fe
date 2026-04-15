import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../bloc/permission/permission_bloc.dart';
import '../../bloc/permission/permission_event.dart';
import '../../bloc/permission/permission_state.dart';
import 'add_permission_page.dart';

class PermissionListPage extends StatefulWidget {
  const PermissionListPage({super.key});

  @override
  State<PermissionListPage> createState() => _PermissionListPageState();
}

class _PermissionListPageState extends State<PermissionListPage> {
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<PermissionBloc>().add(LoadPermissions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF121826)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Daftar Perizinan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF121826),
          ),
        ),
        titleSpacing: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPermissionPage()),
          );
          if (mounted) _loadData();
        },
        backgroundColor: const Color(0xFF2250E8),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'Tambah Izin',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<PermissionBloc, PermissionState>(
        builder: (context, state) {
          if (state is PermissionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PermissionError) {
            return Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: AppColors.error),
              ),
            );
          }

          if (state is! PermissionLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final all = state.permissions;
          final filtered = all.where((p) {
            if (_selectedFilter == 'Semua') return true;
            if (_selectedFilter == 'Sakit') {
              return p.type.toLowerCase() == 'sakit';
            }
            if (_selectedFilter == 'Izin Khusus') {
              return p.type.toLowerCase() == 'izin';
            }
            return true;
          }).toList();

          final waitingBk = all.where((p) => p.isSubmittedToBk).length;
          final approvedBk = all.where((p) => p.isVerifiedByBk).length;

          return RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              children: [
                _buildTopFilters(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatBox(
                        title: 'PENDING BK',
                        value: '$waitingBk',
                        suffix: 'Siswa',
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatBox(
                        title: 'VERIFIKASI BK',
                        value: '$approvedBk',
                        suffix: 'Siswa',
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (filtered.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Belum ada data izin pada filter ini.',
                      style: GoogleFonts.inter(color: const Color(0xFF6B7280)),
                    ),
                  )
                else
                  ...filtered.map(_buildPermissionCard),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopFilters() {
    return Row(
      children: [
        _buildFilterPill('Semua'),
        const SizedBox(width: 8),
        _buildFilterPill('Sakit'),
        const SizedBox(width: 8),
        _buildFilterPill('Izin Khusus'),
      ],
    );
  }

  Widget _buildFilterPill(String label) {
    final active = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF2B5BFF) : const Color(0xFFE8ECF9),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : const Color(0xFF636B80),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String title,
    required String value,
    required String suffix,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.8), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: const Color(0xFF9AA0B5),
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                ),
                TextSpan(
                  text: ' $suffix',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard(dynamic p) {
    final type = p.type.toString().toLowerCase();
    final isSakit = type == 'sakit';
    final isIzin = type == 'izin';

    final typeLabel = isSakit
        ? 'SAKIT'
        : isIzin
        ? 'IZIN'
        : 'DISPENSASI';

    final typeTextColor = isSakit
        ? const Color(0xFFEF4444)
        : isIzin
        ? const Color(0xFF3B82F6)
        : const Color(0xFF6366F1);

    final statusRaw = p.status.toString().toLowerCase();
    final statusLabel = _mapTeacherPermissionStatusLabel(statusRaw);
    final statusColor = _mapTeacherPermissionStatusColor(statusRaw);

    String dateRange = '-';
    try {
      if (p.startDate != null) {
        final start = DateTime.parse(p.startDate!);
        if (p.endDate != null && p.endDate != p.startDate) {
          final end = DateTime.parse(p.endDate!);
          dateRange =
              '${DateFormat('d MMM', 'id_ID').format(start)} - ${DateFormat('d MMM yyyy', 'id_ID').format(end)}';
        } else {
          dateRange = DateFormat('d MMM yyyy', 'id_ID').format(start);
        }
      }
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: const Color(0xFFE6ECFA),
                child: Text(
                  p.student.name
                      .split(' ')
                      .take(2)
                      .map((e) => e[0])
                      .join()
                      .toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2B5BFF),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.student.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'NIS: ${p.student.nis}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF7A8196),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  typeLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: typeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RENTANG WAKTU',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9AA0B5),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateRange,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STATUS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9AA0B5),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          statusLabel,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if ((p.keterangan ?? '').toString().trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '"${p.keterangan}"',
              style: GoogleFonts.inter(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: const Color(0xFF6B7280),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _mapTeacherPermissionStatusLabel(String statusRaw) {
    if ({
      'pending',
      'pending_bk',
      'submitted',
      'menunggu',
    }.contains(statusRaw)) {
      return 'Pending BK';
    }
    if ({'verified_bk', 'pending_wali'}.contains(statusRaw)) {
      return 'Terverifikasi BK';
    }
    if (statusRaw == 'approved') {
      return 'Disetujui';
    }
    if ({'rejected', 'rejected_bk', 'rejected_wali'}.contains(statusRaw)) {
      return 'Ditolak';
    }
    return 'Pending BK';
  }

  Color _mapTeacherPermissionStatusColor(String statusRaw) {
    if ({
      'pending',
      'pending_bk',
      'submitted',
      'menunggu',
    }.contains(statusRaw)) {
      return const Color(0xFF8B5CF6);
    }
    if ({'verified_bk', 'pending_wali'}.contains(statusRaw)) {
      return const Color(0xFF2563EB);
    }
    if (statusRaw == 'approved') {
      return const Color(0xFF22C55E);
    }
    if ({'rejected', 'rejected_bk', 'rejected_wali'}.contains(statusRaw)) {
      return const Color(0xFFEF4444);
    }
    return const Color(0xFF8B5CF6);
  }
}
