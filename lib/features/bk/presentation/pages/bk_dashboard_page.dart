import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/bloc/bloc.dart';
import '../../../auth/data/models/user.dart';

/// BK Dashboard - Main screen for Guru BK (Counselor) role
class BkDashboardPage extends StatelessWidget {
  const BkDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        User? user;
        if (state is AuthAuthenticated) {
          user = state.user;
        }

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 140,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.surface,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildHeader(context, user),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      color: AppColors.onSurfaceVariant,
                      onPressed: () {
                        // TODO: Notifications
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_outlined),
                      color: AppColors.onSurfaceVariant,
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                    ),
                    const SizedBox(width: AppDimensions.spacing2),
                  ],
                ),
                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(AppDimensions.spacing4),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Quick Stats
                      _buildQuickStats(),
                      const SizedBox(height: AppDimensions.spacing6),

                      // Today's Counseling Schedule
                      _buildSectionHeader(
                        'Jadwal Konseling Hari Ini',
                        onSeeAll: () {
                          // TODO: Navigate to full schedule
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacing3),
                      _buildCounselingSchedule(),
                      const SizedBox(height: AppDimensions.spacing6),

                      // Menu Grid
                      _buildSectionHeader('Menu Utama'),
                      const SizedBox(height: AppDimensions.spacing3),
                      _buildMenuGrid(context),
                      const SizedBox(height: AppDimensions.spacing6),

                      // Students Needing Attention
                      _buildSectionHeader(
                        'Siswa Perlu Perhatian',
                        onSeeAll: () {
                          // TODO: Navigate to students list
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacing3),
                      _buildStudentsNeedingAttention(),
                      const SizedBox(height: AppDimensions.spacing8),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, User? user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacing4,
        AppDimensions.spacing4,
        AppDimensions.spacing4,
        AppDimensions.spacing2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.izinContainer,
                child: Text(
                  user?.shortName.substring(0, 1).toUpperCase() ?? 'B',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.izin,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing3),
              // Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      user?.shortName ?? 'Konselor',
                      style: AppTextStyles.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing2),
          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing2,
              vertical: AppDimensions.spacing1,
            ),
            decoration: BoxDecoration(
              color: AppColors.izinContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(
              'Guru BK',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.izin,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.people_outline,
            value: '24',
            label: 'Siswa Binaan',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacing3),
        Expanded(
          child: _buildStatCard(
            icon: Icons.event_note,
            value: '3',
            label: 'Konseling Hari Ini',
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacing3),
        Expanded(
          child: _buildStatCard(
            icon: Icons.warning_amber,
            value: '5',
            label: 'Perlu Tindakan',
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppDimensions.spacing3),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppDimensions.spacing2),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(color: color),
          ),
          const SizedBox(height: AppDimensions.spacing1),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'Lihat Semua',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCounselingSchedule() {
    // TODO: Get actual schedule from API
    return Column(
      children: [
        _buildCounselingItem(
          time: '09:00',
          studentName: 'Ahmad Rizki',
          className: '8A',
          type: 'Konseling Individu',
          status: 'Terjadwal',
        ),
        const SizedBox(height: AppDimensions.spacing2),
        _buildCounselingItem(
          time: '10:30',
          studentName: 'Kelompok 7B',
          className: '7B',
          type: 'Bimbingan Kelompok',
          status: 'Terjadwal',
        ),
        const SizedBox(height: AppDimensions.spacing2),
        _buildCounselingItem(
          time: '13:00',
          studentName: 'Siti Nurhaliza',
          className: '9C',
          type: 'Konseling Karir',
          status: 'Terjadwal',
        ),
      ],
    );
  }

  Widget _buildCounselingItem({
    required String time,
    required String studentName,
    required String className,
    required String type,
    required String status,
  }) {
    return AppCard.standard(
      child: Row(
        children: [
          // Time
          Container(
            width: 56,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacing2,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Column(
              children: [
                Text(
                  time,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacing3),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentName, style: AppTextStyles.titleSmall),
                const SizedBox(height: AppDimensions.spacing1),
                Row(
                  children: [
                    Text(
                      className,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing2),
                    Text(
                      type,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing2,
              vertical: AppDimensions.spacing1,
            ),
            decoration: BoxDecoration(
              color: AppColors.infoContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(
              status,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.info,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final List<_MenuItem> menuItems = [
      _MenuItem(
        icon: Icons.psychology,
        label: 'Konseling',
        color: AppColors.izin,
        onTap: () {
          // TODO: Navigate to counseling
        },
      ),
      _MenuItem(
        icon: Icons.groups,
        label: 'Bimbingan',
        color: AppColors.secondary,
        onTap: () {
          // TODO: Navigate to group guidance
        },
      ),
      _MenuItem(
        icon: Icons.assignment,
        label: 'Catatan Siswa',
        color: AppColors.primary,
        onTap: () {
          // TODO: Navigate to student notes
        },
      ),
      _MenuItem(
        icon: Icons.warning,
        label: 'Pelanggaran',
        color: AppColors.error,
        onTap: () {
          // TODO: Navigate to violations
        },
      ),
      _MenuItem(
        icon: Icons.analytics,
        label: 'Laporan',
        color: AppColors.info,
        onTap: () {
          // TODO: Navigate to reports
        },
      ),
      _MenuItem(
        icon: Icons.person,
        label: 'Profil',
        color: AppColors.onSurfaceVariant,
        onTap: () {
          // TODO: Navigate to profile
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppDimensions.spacing3,
        crossAxisSpacing: AppDimensions.spacing3,
        childAspectRatio: 1,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuItem(item);
      },
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(item.icon, color: item.color, size: 24),
            ),
            const SizedBox(height: AppDimensions.spacing2),
            Text(
              item.label,
              style: AppTextStyles.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsNeedingAttention() {
    // TODO: Get actual data from API
    return Column(
      children: [
        _buildStudentAlert(
          name: 'Budi Santoso',
          className: '8B',
          issue: 'Absen 3 hari berturut-turut',
          severity: AlertSeverity.high,
        ),
        const SizedBox(height: AppDimensions.spacing2),
        _buildStudentAlert(
          name: 'Dewi Lestari',
          className: '7A',
          issue: 'Nilai turun drastis',
          severity: AlertSeverity.medium,
        ),
        const SizedBox(height: AppDimensions.spacing2),
        _buildStudentAlert(
          name: 'Eko Prasetyo',
          className: '9D',
          issue: 'Perlu bimbingan karir',
          severity: AlertSeverity.low,
        ),
      ],
    );
  }

  Widget _buildStudentAlert({
    required String name,
    required String className,
    required String issue,
    required AlertSeverity severity,
  }) {
    Color severityColor;
    IconData severityIcon;

    switch (severity) {
      case AlertSeverity.high:
        severityColor = AppColors.error;
        severityIcon = Icons.error;
        break;
      case AlertSeverity.medium:
        severityColor = AppColors.warning;
        severityIcon = Icons.warning;
        break;
      case AlertSeverity.low:
        severityColor = AppColors.info;
        severityIcon = Icons.info;
        break;
    }

    return AppCard.metric(
      accentBarColor: severityColor,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(severityIcon, color: severityColor, size: 20),
          ),
          const SizedBox(width: AppDimensions.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: AppTextStyles.titleSmall),
                    const SizedBox(width: AppDimensions.spacing2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing1,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXs,
                        ),
                      ),
                      child: Text(className, style: AppTextStyles.labelSmall),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacing1),
                Text(
                  issue,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

enum AlertSeverity { high, medium, low }

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
