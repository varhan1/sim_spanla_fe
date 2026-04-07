import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/bloc/bloc.dart';
import '../../../auth/data/models/user.dart';

/// Teacher Dashboard - Following stitch design (s_03_dashboard_guru_new_style)
class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  int _selectedNavIndex = 0;

  // Colors from stitch design
  static const Color _primary = Color(0xFF0040DF);
  static const Color _primaryContainer = Color(0xFF2D5BFF);
  static const Color _surface = Color(0xFFFAF8FF);
  static const Color _surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color _surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color _onSurface = Color(0xFF131B2E);
  static const Color _onSurfaceVariant = Color(0xFF434655);
  static const Color _outline = Color(0xFF737686);
  static const Color _outlineVariant = Color(0xFFC3C6D7);
  static const Color _tertiary = Color(0xFF7A1BC8);
  static const Color _tertiaryContainer = Color(0xFF943FE2);
  static const Color _error = Color(0xFFBA1A1A);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        User? user;
        if (state is AuthAuthenticated) {
          user = state.user;
        }

        final topPadding = MediaQuery.of(context).padding.top;
        final appBarHeight = topPadding + 72; // status bar + app bar content

        return Scaffold(
          backgroundColor: _surface,
          body: Stack(
            children: [
              // Main Content
              CustomScrollView(
                slivers: [
                  // TopAppBar spacing
                  SliverToBoxAdapter(
                    child: SizedBox(height: appBarHeight + 16),
                  ),
                  // Content
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Check-In Banner
                        _buildCheckInBanner(user),
                        const SizedBox(height: 40),

                        // Metrics Bento Grid
                        _buildMetricsGrid(user),
                        const SizedBox(height: 40),

                        // Today's Schedule
                        _buildScheduleSection(),
                        const SizedBox(height: 40),

                        // Jurnal Progress
                        _buildJournalProgressCard(user),
                      ]),
                    ),
                  ),
                ],
              ),

              // Fixed TopAppBar
              _buildTopAppBar(user),

              // Fixed BottomNavBar
              _buildBottomNavBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopAppBar(User? user) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              24,
              MediaQuery.of(context).padding.top + 16,
              24,
              16,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(179), // 0.7 opacity
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF131B2E).withAlpha(15), // 0.06 opacity
                  blurRadius: 40,
                ),
              ],
            ),
            child: Row(
              children: [
                // Profile Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _primaryContainer.withAlpha(26), // 0.1 opacity
                    border: Border.all(
                      color: _primary.withAlpha(26), // 0.1 opacity
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Text(
                        user?.shortName.substring(0, 1).toUpperCase() ?? 'G',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Greeting
                Expanded(
                  child: Text(
                    '${_getGreeting()}, ${user?.shortName ?? 'Guru'}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: _onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Notification Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // TODO: Notifications
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: _primaryContainer,
                        size: 24,
                      ),
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

  Widget _buildCheckInBanner(User? user) {
    // TODO: Get actual check-in status from API
    final bool isCheckedIn = false;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFB923C),
            Color(0xFFD97706),
          ], // orange-400 to amber-600
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFB923C).withAlpha(51), // 0.2 opacity
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative blur circle
          Positioned(
            right: -32,
            top: -32,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(26), // 0.1 opacity
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FOKUS HARI INI',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Colors.white.withAlpha(204), // 0.8 opacity
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  isCheckedIn
                      ? 'Anda sudah check-in hari ini!'
                      : 'Siap untuk memulai hari?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Check-in Button
                  _buildBannerButton(
                    label: isCheckedIn ? 'Sudah Check-in' : 'Check-in',
                    icon: Icons.arrow_forward,
                    isPrimary: true,
                    enabled: !isCheckedIn,
                    onTap: () {
                      // TODO: Navigate to check-in
                    },
                  ),
                  const SizedBox(width: 12),
                  // Check-out Button
                  _buildBannerButton(
                    icon: Icons.logout,
                    isPrimary: false,
                    enabled: isCheckedIn,
                    onTap: () {
                      // TODO: Navigate to check-out
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerButton({
    String? label,
    required IconData icon,
    required bool isPrimary,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(9999),
        child: Container(
          padding: label != null
              ? const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
              : const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: enabled
                ? Colors.white.withAlpha(51) // 0.2 opacity
                : Colors.white.withAlpha(26), // 0.1 opacity
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: Colors.white.withAlpha(77), // 0.3 opacity
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null) ...[
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: enabled ? Colors.white : Colors.white70,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                icon,
                color: enabled ? Colors.white : Colors.white70,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(User? user) {
    // TODO: Get actual metrics from API
    return Row(
      children: [
        // Metric 1 - Jadwal Hari Ini
        Expanded(
          child: _buildMetricCard(
            icon: Icons.bolt,
            iconBgColor: _primaryContainer.withAlpha(26), // 0.1 opacity
            iconColor: _primary,
            label: 'JADWAL',
            value: '6',
            suffix: 'JP',
            subtitle: 'Jam Pelajaran',
          ),
        ),
        const SizedBox(width: 16),
        // Metric 2 - Jurnal Progress
        Expanded(
          child: _buildMetricCard(
            icon: Icons.task_alt,
            iconBgColor: _tertiaryContainer.withAlpha(26), // 0.1 opacity
            iconColor: _tertiary,
            label: 'JURNAL',
            value: '4',
            suffix: '/6',
            subtitle: 'Hampir selesai',
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    required String suffix,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF131B2E).withAlpha(10), // 0.04 opacity
            blurRadius: 40,
          ),
        ],
        border: Border.all(
          color: _outlineVariant.withAlpha(26), // 0.1 opacity
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: _outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -1,
                  color: _onSurface,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  suffix,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: _onSurface.withAlpha(102), // 0.4 opacity
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _onSurfaceVariant.withAlpha(153), // 0.6 opacity
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jadwal Hari Ini',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: _onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getFormattedDate(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: _onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full schedule
                },
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Schedule Items
        // Item 1 - DONE
        _buildScheduleItem(
          time: '07:30',
          period: 'JP 1-2',
          title: 'Matematika',
          subtitle: 'Kelas 7A - Ruang 101',
          status: ScheduleStatus.done,
        ),
        const SizedBox(height: 12),

        // Item 2 - OPEN (current)
        _buildScheduleItem(
          time: '09:15',
          period: 'JP 3-4',
          title: 'Bahasa Indonesia',
          subtitle: 'Kelas 8B - Ruang 203',
          status: ScheduleStatus.open,
        ),
        const SizedBox(height: 12),

        // Item 3 - LOCKED
        _buildScheduleItem(
          time: '11:00',
          period: 'JP 5-6',
          title: 'IPA',
          subtitle: 'Kelas 9C - Lab IPA',
          status: ScheduleStatus.locked,
        ),
      ],
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}';
  }

  Widget _buildScheduleItem({
    required String time,
    required String period,
    required String title,
    required String subtitle,
    required ScheduleStatus status,
  }) {
    final isOpen = status == ScheduleStatus.open;
    final isDone = status == ScheduleStatus.done;
    final isLocked = status == ScheduleStatus.locked;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOpen ? _surfaceContainerLowest : _surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: isOpen
            ? Border.all(color: _primary.withAlpha(26), width: 1)
            : null,
        boxShadow: isOpen
            ? [
                BoxShadow(
                  color: const Color(0xFF131B2E).withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Opacity(
        opacity: isLocked ? 0.6 : 1.0,
        child: Row(
          children: [
            // Left accent bar for open item
            if (isOpen)
              Container(
                width: 4,
                height: 48,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            // Time
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isOpen
                    ? _primaryContainer.withAlpha(26)
                    : isDone
                    ? Colors.white
                    : const Color(0xFFE2E8F0), // slate-200
                borderRadius: BorderRadius.circular(16),
                boxShadow: isDone
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time.split(':')[0],
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isOpen ? _primary : _outline,
                    ),
                  ),
                  Text(
                    time.split(':')[1],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: isOpen ? _primary : _onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: _onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Status Badge
            _buildStatusBadge(status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ScheduleStatus status) {
    Color bgColor;
    Color textColor;
    String label;
    IconData? icon;

    switch (status) {
      case ScheduleStatus.done:
        bgColor = const Color(0xFFDCFCE7); // green-100
        textColor = const Color(0xFF15803D); // green-700
        label = 'SELESAI';
        break;
      case ScheduleStatus.open:
        bgColor = _primary;
        textColor = Colors.white;
        label = 'AKTIF';
        break;
      case ScheduleStatus.locked:
        bgColor = const Color(0xFFE2E8F0); // slate-200
        textColor = const Color(0xFF64748B); // slate-500
        label = 'TERKUNCI';
        icon = Icons.lock;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalProgressCard(User? user) {
    // TODO: Get actual progress from API
    const double progress = 0.67; // 4/6 = 67%

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E7FF), // surface-container-high
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Decorative blur circle
          Positioned(
            right: -48,
            bottom: -48,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _tertiary.withAlpha(13), // 0.05 opacity
              ),
            ),
          ),
          // Content
          Row(
            children: [
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jurnal Mengajar',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: const Color(
                          0xFF0035BD,
                        ), // on-secondary-fixed-variant
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF07006C,
                              ).withAlpha(26), // 0.1 opacity
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _tertiary,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _tertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Action Button
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to journal
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lanjutkan Menulis',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(
                                0xFF07006C,
                              ), // on-secondary-fixed
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.play_circle,
                            size: 18,
                            color: Color(0xFF07006C),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Circular Progress
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Circle
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CircularProgressIndicator(
                        value: 1,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withAlpha(
                          51,
                        ), // 0.2 opacity
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withAlpha(51),
                        ),
                      ),
                    ),
                    // Progress Circle
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          _tertiary,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    // Center Text
                    Text(
                      '4/6',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF07006C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(179), // 0.7 opacity
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF131B2E).withAlpha(15), // 0.06 opacity
                  blurRadius: 40,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.grid_view, 'Dashboard'),
                _buildNavItem(1, Icons.calendar_today, 'Jadwal'),
                _buildNavItem(2, Icons.qr_code_scanner, 'Scan'),
                _buildNavItem(3, Icons.person, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedNavIndex = index);
        if (index == 3) {
          // Profile - show logout dialog
          _showLogoutDialog();
        }
        // TODO: Handle other navigation
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 20,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF60A5FA),
                  ], // blue-600 to blue-400
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withAlpha(51), // 0.2 opacity
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? _getFilledIcon(icon) : icon,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF94A3B8), // slate-400
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFilledIcon(IconData icon) {
    // Return filled version of icon
    if (icon == Icons.grid_view) return Icons.grid_view;
    if (icon == Icons.calendar_today) return Icons.calendar_today;
    if (icon == Icons.qr_code_scanner) return Icons.qr_code_scanner;
    if (icon == Icons.person) return Icons.person;
    return icon;
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: _onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: _error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ScheduleStatus { done, open, locked }
