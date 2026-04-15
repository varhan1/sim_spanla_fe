import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/models/permission.dart';
import '../../bloc/permission/permission_bloc.dart';
import '../../bloc/permission/permission_event.dart';
import '../../bloc/permission/permission_state.dart';

class AddPermissionPage extends StatefulWidget {
  const AddPermissionPage({super.key});

  @override
  State<AddPermissionPage> createState() => _AddPermissionPageState();
}

class _AddPermissionPageState extends State<AddPermissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();

  List<StudentPermission> _students = [];
  StudentPermission? _selectedStudent;
  String _permissionType = 'sakit';
  DateTime? _startDate;
  DateTime? _endDate;
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    context.read<PermissionBloc>().add(LoadStudents());
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _selectedFile = File(pickedFile.path));
    }
  }

  Future<void> _selectDate(bool isStart) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? _startDate ?? DateTime.now());

    final firstDate = isStart ? DateTime(2000) : (_startDate ?? DateTime(2000));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
    );

    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      } else {
        _endDate = picked;
      }
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedStudent != null &&
        _startDate != null &&
        _endDate != null) {
      context.read<PermissionBloc>().add(
        SubmitPermission(
          studentId: _selectedStudent!.id,
          type: _permissionType,
          startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
          endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
          keterangan: _keteranganController.text,
          foto: _selectedFile,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mohon lengkapi semua field wajib')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF121826)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tambah Perizinan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF121826),
            fontSize: 20,
          ),
        ),
      ),
      body: BlocConsumer<PermissionBloc, PermissionState>(
        listener: (context, state) {
          if (state is PermissionStudentsLoaded) {
            setState(() => _students = state.students);
          } else if (state is PermissionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context, true);
          } else if (state is PermissionError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final loading = state is PermissionLoading;

          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Text(
                      'SETUP PERIZINAN',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF3B6AF8),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Konfigurasi Izin Siswa',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF121826),
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 22),

                    _label('Pilih Siswa'),
                    const SizedBox(height: 8),
                    _buildStudentDropdown(),

                    const SizedBox(height: 16),
                    _label('Jenis Izin'),
                    const SizedBox(height: 8),
                    _buildTypeSelector(),

                    const SizedBox(height: 16),
                    _label('Tanggal Mulai'),
                    const SizedBox(height: 8),
                    _buildDateCard(_startDate, () => _selectDate(true)),

                    const SizedBox(height: 16),
                    _label('Tanggal Selesai'),
                    const SizedBox(height: 8),
                    _buildDateCard(_endDate, () => _selectDate(false)),

                    const SizedBox(height: 16),
                    _label('Keterangan (Opsional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _keteranganController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Tuliskan alasan izin...',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE8ECF7),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE8ECF7),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    _label('Lampiran Bukti (Opsional)'),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE8ECF7)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attachment_rounded,
                              color: Color(0xFF2250E8),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedFile != null
                                    ? _selectedFile!.path.split('/').last
                                    : 'Tap untuk pilih foto bukti',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: _selectedFile != null
                                      ? const Color(0xFF121826)
                                      : const Color(0xFF8A93A8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: loading ? null : _submit,
                        icon: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_rounded),
                        label: Text(
                          loading ? 'Menyimpan...' : 'Simpan Perizinan',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2250E8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF8A93A8),
      ),
    );
  }

  Widget _buildStudentDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE8ECF7)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<StudentPermission>(
          value: _selectedStudent,
          isExpanded: true,
          hint: Text(
            'Pilih siswa',
            style: GoogleFonts.inter(color: const Color(0xFF8A93A8)),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFFA1A8BC),
          ),
          items: _students
              .map(
                (student) => DropdownMenuItem(
                  value: student,
                  child: Text(
                    '${student.name} (${student.nis})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedStudent = value),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _typePill('sakit', 'Sakit')),
          Expanded(child: _typePill('izin', 'Izin')),
        ],
      ),
    );
  }

  Widget _typePill(String value, String label) {
    final selected = _permissionType == value;
    return InkWell(
      onTap: () => setState(() => _permissionType = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2250E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(DateTime? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8ECF7)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              color: Color(0xFF2250E8),
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value == null
                    ? 'Pilih tanggal'
                    : DateFormat('dd MMM yyyy', 'id_ID').format(value),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: value == null
                      ? const Color(0xFF8A93A8)
                      : const Color(0xFF1F2937),
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFFA1A8BC),
            ),
          ],
        ),
      ),
    );
  }
}
