import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/bloc/bloc.dart';
import '../../../auth/data/models/user.dart';

/// BK Dashboard - Following stitch design (s_14_dashboard_bk_new_style)
class BkDashboardPage extends StatefulWidget {
  const BkDashboardPage({super.key});

  @override
  State<BkDashboardPage> createState() => _BkDashboardPageState();
}

class _BkDashboardPageState extends State<BkDashboardPage> {
  int _selectedNavIndex = 0;

  // Colors from stitch design
  static const Color _primary = Color(0xFF0040DF);
  static const Color _primaryContainer = Color(0xFF2D5BFF);
  static const Color _surface = Color(0xFFFAF8FF);
  static const Color _surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color _surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color _onSurface = Color(0xFF131B2E);
  static const Color _onSurfaceVariant = Color(0xFF434655);
  static const Color _outline = Color(0xFF737686);
  static const Color _outlineVariant = Color(0xFFC3C6D7);
  static const Color _tertiary = Color(0xFF7A1BC8);
  static const Color _tertiaryContainer = Color(0xFF943FE2);
  static const Color _secondary = Color(0xFF4648D4);
  static const Color _secondaryContainer = Color(0xFF6063EE);
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
                        // Welcome Section & Primary Action
                        _buildWelcomeSection(user),
                        const SizedBox(height: 40),

                        // Metrics Bento Grid (4 cards)
                        _buildMetricsGrid(),
                        const SizedBox(height: 40),

                        // Content Layout: Critical Monitoring + System Health
                        _buildContentSection(),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _surfaceContainerHigh,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Text(
                        user?.shortName.substring(0, 1).toUpperCase() ?? 'B',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Greeting
                Expanded(
                  child: Text(
                    '${_getGreeting()}, ${user?.shortName ?? 'Konselor'}',
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
                      width: 48,
                      height: 48,
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

  Widget _buildWelcomeSection(User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'OVERVIEW DASHBOARD',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: _primaryContainer,
          ),
        ),
        const SizedBox(height: 8),
        // Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Monitoring BK',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: _onSurface,
                ),
              ),
            ),
            // Primary Action Button
            _buildPrimaryActionButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildPrimaryActionButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Log new incident
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primary, _primaryContainer],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _primary.withAlpha(51), // 0.2 opacity
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                'Catat Kasus',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      children: [
        // Row 1
        Row(
          children: [
            // Metric 1 - Total Kehadiran
            Expanded(
              child: _buildMetricCard(
                icon: Icons.analytics,
                iconBgColor: _primaryContainer.withAlpha(26),
                iconColor: _primary,
                value: '1,284',
                label: 'TOTAL KEHADIRAN',
                badge: '+12%',
                badgeColor: const Color(0xFF16A34A), // green-600
                badgeBgColor: const Color(0xFFDCFCE7), // green-50
              ),
            ),
            const SizedBox(width: 16),
            // Metric 2 - Pelanggaran Aktif
            Expanded(
              child: _buildMetricCard(
                icon: Icons.warning,
                iconBgColor: _tertiaryContainer.withAlpha(26),
                iconColor: _tertiary,
                value: '42',
                label: 'PELANGGARAN AKTIF',
                badge: '-4%',
                badgeColor: const Color(0xFFDC2626), // red-600
                badgeBgColor: const Color(0xFFFEE2E2), // red-50
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2
        Row(
          children: [
            // Metric 3 - Skor Integritas
            Expanded(
              child: _buildMetricCard(
                icon: Icons.verified_user,
                iconBgColor: _secondaryContainer.withAlpha(26),
                iconColor: _secondary,
                value: '98.2',
                valueSuffix: '%',
                label: 'SKOR INTEGRITAS',
                badge: 'Stabil',
                badgeColor: const Color(0xFF16A34A),
                badgeBgColor: const Color(0xFFDCFCE7),
              ),
            ),
            const SizedBox(width: 16),
            // Metric 4 - Siswa Binaan
            Expanded(
              child: _buildMetricCard(
                icon: Icons.rocket_launch,
                iconBgColor: const Color(0xFFDBEAFE), // blue-100
                iconColor: const Color(0xFF2563EB), // blue-600
                value: '156',
                label: 'SISWA BINAAN',
                badge: 'Target',
                badgeColor: const Color(0xFF2563EB),
                badgeBgColor: const Color(0xFFDBEAFE),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String value,
    String? valueSuffix,
    required String label,
    required String badge,
    required Color badgeColor,
    required Color badgeBgColor,
  }) {
    return Container(
      height: 176,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(179), // glass effect
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF131B2E).withAlpha(15),
            blurRadius: 40,
          ),
        ],
        border: Border.all(
          color: _outlineVariant.withAlpha(51), // 0.2 opacity
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Icon + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          // Bottom: Value + Label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: _onSurface,
                    ),
                  ),
                  if (valueSuffix != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 2),
                      child: Text(
                        valueSuffix,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: _onSurface,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: _onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Critical Monitoring Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monitoring Kritis',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: _onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: View all
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
        const SizedBox(height: 24),

        // Violator List
        _buildViolatorItem(
          initials: 'AS',
          name: 'Ahmad Santoso',
          id: '#88291',
          violation: '8X ALPA',
          violationColor: const Color(0xFFDC2626), // red
          bgColor: const Color(0xFFFEE2E2),
        ),
        const SizedBox(height: 16),
        _buildViolatorItem(
          initials: 'SM',
          name: 'Sarah Maulida',
          id: '#88295',
          violation: '3X TERLAMBAT',
          violationColor: const Color(0xFF2563EB), // blue
          bgColor: const Color(0xFFDBEAFE),
        ),
        const SizedBox(height: 16),
        _buildViolatorItem(
          initials: 'RK',
          name: 'Rudi Kurniawan',
          id: '#88301',
          violation: '5X IZIN',
          violationColor: const Color(0xFFEA580C), // orange
          bgColor: const Color(0xFFFED7AA),
        ),
        const SizedBox(height: 16),
        _buildViolatorItem(
          initials: 'DW',
          name: 'Dewi Wulandari',
          id: '#88310',
          violation: '7X ALPA',
          violationColor: const Color(0xFFDC2626),
          bgColor: const Color(0xFFFEE2E2),
        ),

        const SizedBox(height: 40),

        // System Health Section
        _buildSystemHealthCard(),
      ],
    );
  }

  Widget _buildViolatorItem({
    required String initials,
    required String name,
    required String id,
    required String violation,
    required Color violationColor,
    required Color bgColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to detail
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: violationColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: $id',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Violation Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  violation,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: violationColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Chevron
              Icon(Icons.chevron_right, color: _outline, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemHealthCard() {
    const double progress = 0.75; // 75%

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(179),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outlineVariant.withAlpha(51), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kesehatan Sistem',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: _onSurface,
            ),
          ),
          const SizedBox(height: 24),
          // Progress Circle + Info
          Row(
            children: [
              // Progress Circle
              SizedBox(
                width: 192,
                height: 192,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Circle
                    SizedBox(
                      width: 176,
                      height: 176,
                      child: CircularProgressIndicator(
                        value: 1,
                        strokeWidth: 8,
                        backgroundColor: _surfaceContainerHigh,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _surfaceContainerHigh,
                        ),
                      ),
                    ),
                    // Progress Circle
                    SizedBox(
                      width: 176,
                      height: 176,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          _tertiary,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    // Center Text
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: _onSurface,
                          ),
                        ),
                        Text(
                          'TARGET TERCAPAI',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: _onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Efisiensi Mingguan',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Monitoring BK berjalan dalam parameter optimal untuk minggu ke-3 berturut-turut.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Download Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // TODO: Download report
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              'Download Laporan',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(
                                  0xFF0035BD,
                                ), // on-primary-fixed-variant
                              ),
                            ),
                          ),
                        ),
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
              isSelected ? icon : icon,
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
