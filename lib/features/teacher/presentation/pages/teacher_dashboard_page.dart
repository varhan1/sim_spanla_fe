import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/bloc/bloc.dart';
import '../../../auth/data/models/user.dart';

/// Teacher Dashboard - Main screen for Guru role
class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

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
                      // Quick Actions - Check In/Out
                      _buildCheckInSection(context, user),
                      const SizedBox(height: AppDimensions.spacing6),

                      // Today's Schedule
                      _buildSectionHeader(
                        'Jadwal Hari Ini',
                        onSeeAll: () {
                          // TODO: Navigate to full schedule
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacing3),
                      _buildScheduleCard(),
                      const SizedBox(height: AppDimensions.spacing6),

                      // Menu Grid
                      _buildSectionHeader('Menu Utama'),
                      const SizedBox(height: AppDimensions.spacing3),
                      _buildMenuGrid(context, user),
                      const SizedBox(height: AppDimensions.spacing6),

                      // Recent Activity
                      _buildSectionHeader(
                        'Aktivitas Terbaru',
                        onSeeAll: () {
                          // TODO: Navigate to activity history
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacing3),
                      _buildRecentActivity(),
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
                backgroundColor: AppColors.primaryFixed,
                child: Text(
                  user?.shortName.substring(0, 1).toUpperCase() ?? 'G',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primary,
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
                      user?.shortName ?? 'Guru',
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
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(
              user?.isWaliKelas == true
                  ? 'Wali Kelas ${user?.waliKelas ?? ''}'
                  : 'Guru',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInSection(BuildContext context, User? user) {
    // TODO: Get actual check-in status from API
    final bool isCheckedIn = false;

    return AppCard.elevated(
      child: Column(
        children: [
          Row(
            children: [
              // Status Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isCheckedIn
                      ? AppColors.successContainer
                      : AppColors.warningContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(
                  isCheckedIn ? Icons.check_circle : Icons.access_time,
                  color: isCheckedIn ? AppColors.success : AppColors.warning,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing4),
              // Status Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCheckedIn ? 'Sudah Check-in' : 'Belum Check-in',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.spacing1),
                    Text(
                      isCheckedIn
                          ? 'Check-in: 07:15 WIB'
                          : 'Silakan lakukan check-in',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing4),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.login,
                  label: 'Check-in',
                  color: AppColors.success,
                  enabled: !isCheckedIn,
                  onTap: () {
                    // TODO: Navigate to check-in
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.spacing3),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.logout,
                  label: 'Check-out',
                  color: AppColors.error,
                  enabled: isCheckedIn,
                  onTap: () {
                    // TODO: Navigate to check-out
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: enabled
          ? color.withOpacity(0.1)
          : AppColors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: enabled ? color : AppColors.onSurfaceTertiary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacing2),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: enabled ? color : AppColors.onSurfaceTertiary,
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildScheduleCard() {
    // TODO: Get actual schedule from API
    return AppCard.metric(
      accentBarColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacing2),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: const Icon(
                  Icons.schedule,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('07:30 - 09:00', style: AppTextStyles.titleSmall),
                    Text(
                      'Matematika - Kelas 7A',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
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
                  'Berlangsung',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing3),
          const Divider(height: 1),
          const SizedBox(height: AppDimensions.spacing3),
          Row(
            children: [
              const Icon(
                Icons.arrow_forward,
                color: AppColors.onSurfaceVariant,
                size: 16,
              ),
              const SizedBox(width: AppDimensions.spacing2),
              Text(
                'Selanjutnya: 09:15 - Bahasa Indonesia - Kelas 8B',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, User? user) {
    final List<_MenuItem> menuItems = [
      _MenuItem(
        icon: Icons.calendar_today,
        label: 'Jadwal',
        color: AppColors.primary,
        onTap: () {
          // TODO: Navigate to schedule
        },
      ),
      _MenuItem(
        icon: Icons.book,
        label: 'Jurnal',
        color: AppColors.secondary,
        onTap: () {
          // TODO: Navigate to journal
        },
      ),
      if (user?.isWaliKelas == true)
        _MenuItem(
          icon: Icons.people,
          label: 'Absensi Siswa',
          color: AppColors.tertiary,
          onTap: () {
            // TODO: Navigate to student attendance
          },
        ),
      _MenuItem(
        icon: Icons.history,
        label: 'Riwayat',
        color: AppColors.info,
        onTap: () {
          // TODO: Navigate to history
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

  Widget _buildRecentActivity() {
    // TODO: Get actual activity from API
    return Column(
      children: [
        _buildActivityItem(
          icon: Icons.login,
          title: 'Check-in',
          subtitle: 'Hari ini, 07:15',
          color: AppColors.success,
        ),
        const SizedBox(height: AppDimensions.spacing2),
        _buildActivityItem(
          icon: Icons.book,
          title: 'Jurnal: Matematika 7A',
          subtitle: 'Kemarin, 09:30',
          color: AppColors.secondary,
        ),
        const SizedBox(height: AppDimensions.spacing2),
        _buildActivityItem(
          icon: Icons.people,
          title: 'Absensi Siswa: 7F',
          subtitle: 'Kemarin, 07:00',
          color: AppColors.tertiary,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return AppCard.standard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppDimensions.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                Text(
                  subtitle,
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
