import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/journal_bloc.dart';

/// Journal Form Page - Material, cleanliness, and submission
/// Design reference: stitch/s_07_journal_form
class JournalFormPage extends StatefulWidget {
  const JournalFormPage({super.key});

  @override
  State<JournalFormPage> createState() => _JournalFormPageState();
}

class _JournalFormPageState extends State<JournalFormPage> {
  final _materiController = TextEditingController();
  final _imagePicker = ImagePicker();
  String _selectedCleanliness = 'Bersih';

  final _cleanlinessOptions = ['Sangat Bersih', 'Bersih', 'Cukup', 'Kurang'];

  @override
  void dispose() {
    _materiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null && mounted) {
      context.read<JournalBloc>().add(SetAttachment(File(pickedFile.path)));
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null && mounted) {
      context.read<JournalBloc>().add(SetAttachment(File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalBloc, JournalState>(
      listener: (context, state) {
        if (state is JournalSubmitSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Navigate back to schedule
          Navigator.of(context).popUntil(
            (route) => route.isFirst || route.settings.name == '/schedule',
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        } else if (state is JournalError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is JournalSubmitting) {
          return Scaffold(
            backgroundColor: AppColors.surface,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 24),
                  Text('Menyimpan jurnal...', style: AppTextStyles.titleMedium),
                ],
              ),
            ),
          );
        }

        if (state is! JournalStudentsLoaded) {
          return const Scaffold(body: Center(child: Text('State tidak valid')));
        }

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white.withOpacity(0.9),
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.onSurface,
                  ),
                ),
                title: Text(
                  'Form Jurnal',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header badges
                      Row(
                        children: [
                          _buildBadge(
                            'Tahun Ajaran 2024/2025',
                            AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          _buildBadge('Form S-07', AppColors.izin),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        'Teaching Journal.',
                        style: AppTextStyles.displaySmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lengkapi laporan KBM harian Anda.',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Material Taught Card
                      _buildMaterialCard(state),

                      const SizedBox(height: 20),

                      // Attendance Summary Card
                      _buildAttendanceSummary(state),

                      const SizedBox(height: 20),

                      // Side by side: Cleanliness & Attachment
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildCleanlinessCard(state)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Attachment Card
                      _buildAttachmentCard(state),

                      const SizedBox(height: 32),

                      // Submit Button
                      _buildSubmitButton(context, state),

                      const SizedBox(height: 16),

                      // View History Button
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            // TODO: Navigate to history
                          },
                          icon: const Icon(Icons.history, size: 18),
                          label: const Text('Lihat Riwayat Jurnal'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMaterialCard(JournalStudentsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowAmbient,
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DOKUMENTASI INTI',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Materi Pembelajaran',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _materiController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  'Jelaskan topik yang dibahas, tujuan pembelajaran yang dicapai, dan metode yang digunakan hari ini...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant.withOpacity(0.5),
              ),
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: AppTextStyles.bodyLarge,
            onChanged: (value) {
              context.read<JournalBloc>().add(UpdateMaterial(value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary(JournalStudentsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rekap Kehadiran',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Kelas: ${state.className}',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildSummaryItem('HADIR', state.hadirCount, AppColors.primary),
              const SizedBox(width: 12),
              _buildSummaryItem('SAKIT', state.sakitCount, AppColors.info),
              const SizedBox(width: 12),
              _buildSummaryItem('IZIN', state.izinCount, AppColors.izin),
              const SizedBox(width: 12),
              _buildSummaryItem('ALPA', state.alpaCount, AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count.toString().padLeft(2, '0'),
              style: AppTextStyles.headlineMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanlinessCard(JournalStudentsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATUS LINGKUNGAN',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Kebersihan Kelas',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCleanliness,
                isExpanded: true,
                icon: const Icon(Icons.expand_more),
                items: _cleanlinessOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option, style: AppTextStyles.bodyLarge),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCleanliness = value;
                    });
                    context.read<JournalBloc>().add(UpdateCleanliness(value));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentCard(JournalStudentsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowAmbient,
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lampiran',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // Upload area
          GestureDetector(
            onTap: () => _showAttachmentOptions(),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.outlineVariant.withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload_outlined,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Upload Foto/File',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap untuk memilih file',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // File preview
          if (state.attachment != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(state.attachment!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.attachment!.path.split('/').last,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Foto lampiran',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<JournalBloc>().add(SetAttachment(null));
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.error,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pilih Sumber',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.primary),
              ),
              title: Text('Kamera', style: AppTextStyles.titleMedium),
              subtitle: Text(
                'Ambil foto langsung',
                style: AppTextStyles.bodySmall,
              ),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.photo_library, color: AppColors.info),
              ),
              title: Text('Galeri', style: AppTextStyles.titleMedium),
              subtitle: Text(
                'Pilih dari galeri',
                style: AppTextStyles.bodySmall,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, JournalStudentsLoaded state) {
    final isValid = _materiController.text.trim().isNotEmpty;

    return GestureDetector(
      onTap: isValid
          ? () {
              context.read<JournalBloc>().add(SubmitJournal());
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: isValid
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0040DF), Color(0xFF4648D4)],
                )
              : null,
          color: isValid ? null : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isValid
              ? [
                  BoxShadow(
                    color: const Color(0xFF0040DF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.save,
              color: isValid ? Colors.white : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              'Simpan Jurnal',
              style: AppTextStyles.titleLarge.copyWith(
                color: isValid ? Colors.white : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
