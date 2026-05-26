import 'package:flutter/material.dart';
import 'exam_history_page.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

// ── Exam model ────────────────────────────────────────────────────────────────

class ExamEntry {
  String title;
  String type;
  String office;
  String? lectureVideoUrl;
  int questionCount;
  DateTime startAt;
  DateTime dueAt;
  bool isActive;

  ExamEntry({
    required this.title,
    required this.type,
    required this.office,
    this.lectureVideoUrl,
    required this.questionCount,
    required this.startAt,
    required this.dueAt,
    this.isActive = true,
  });
}

// ── Page ──────────────────────────────────────────────────────────────────────

class ExaminationManagementPage extends StatefulWidget {
  const ExaminationManagementPage({super.key});

  @override
  State<ExaminationManagementPage> createState() =>
      _ExaminationManagementPageState();
}

class _ExaminationManagementPageState
    extends State<ExaminationManagementPage> {
  static const _types = ['Multiple Choice', 'Enumeration', 'Fill in the Blank'];
  static const _typeColors = [kGreen, Color(0xFFE7AB38), Color(0xFF5B8DD9)];
  static const _offices = [
    'Internal Medicine', 'Hospital Essentials', 'Midterm Exam', 'Patient Care', 'ICU'
  ];

  final List<ExamEntry> _exams = List.generate(
    6,
    (i) => ExamEntry(
      title: 'Exam ${i + 1}: Office Procedures',
      type: ['Multiple Choice', 'Enumeration', 'Fill in the Blank'][i % 3],
      office: ['Internal Medicine', 'Hospital Essentials', 'Midterm Exam'][i % 3],
      questionCount: 20,
      startAt: DateTime(2026, 5, i + 1, 9, 0),
      dueAt: DateTime(2026, 5, i + 1, 17, 0),
    ),
  );

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  •  $h:$m $p';
  }

  Future<DateTime?> _pickDateTime(
      BuildContext context, DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kGreen,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: kGreenDark,
          ),
        ),
        child: child!,
      ),
    );
    if (date == null || !context.mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kGreen,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: kGreenDark,
          ),
        ),
        child: child!,
      ),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // ── Create / Edit exam dialog ─────────────────────────────────────────────

  void _showExamDialog({ExamEntry? exam}) {
    final titleCtrl = TextEditingController(text: exam?.title ?? '');
    String selectedType = exam?.type ?? _types[0];
    String selectedOffice = exam?.office ?? _offices[0];
    final now = DateTime.now();
    DateTime startAt = exam?.startAt ?? DateTime(now.year, now.month, now.day, 9, 0);
    DateTime dueAt = exam?.dueAt ??
        DateTime(now.year, now.month, now.day, 17, 0);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 480,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.85,
            ),
            padding: const EdgeInsets.all(28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          exam == null ? Icons.add_rounded : Icons.edit_rounded,
                          color: kGreen, size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(exam == null ? 'Create Exam' : 'Edit Exam',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: kGreenDark)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.grey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: titleCtrl,
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                            decoration:
                                _fieldDeco('Exam Title', Icons.quiz_outlined),
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            value: selectedType,
                            decoration: _fieldDeco(
                                'Exam Type', Icons.category_outlined),
                            items: _types
                                .map((t) =>
                                    DropdownMenuItem(value: t, child: Text(t)))
                                .toList(),
                            onChanged: (v) => setDlg(() => selectedType = v!),
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            value: selectedOffice,
                            decoration: _fieldDeco(
                                'Assign Office', Icons.business_outlined),
                            items: _offices
                                .map((o) => DropdownMenuItem(
                                    value: o, child: Text(o)))
                                .toList(),
                            onChanged: (v) =>
                                setDlg(() => selectedOffice = v!),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Exam Schedule',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: kGreenDark),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Set when examinees can start and when the exam closes.',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          _ScheduleField(
                            label: 'Start Time',
                            icon: Icons.play_circle_outline_rounded,
                            value: _formatDateTime(startAt),
                            onTap: () async {
                              final picked =
                                  await _pickDateTime(ctx, startAt);
                              if (picked != null) {
                                setDlg(() => startAt = picked);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          _ScheduleField(
                            label: 'Due Time',
                            icon: Icons.event_busy_outlined,
                            value: _formatDateTime(dueAt),
                            onTap: () async {
                              final picked = await _pickDateTime(ctx, dueAt);
                              if (picked != null) {
                                setDlg(() => dueAt = picked);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            if (!dueAt.isAfter(startAt)) {
                              _snack('Due time must be after start time');
                              return;
                            }
                            setState(() {
                              if (exam == null) {
                                _exams.add(ExamEntry(
                                  title: titleCtrl.text.trim(),
                                  type: selectedType,
                                  office: selectedOffice,
                                  questionCount: 0,
                                  startAt: startAt,
                                  dueAt: dueAt,
                                ));
                              } else {
                                exam.title = titleCtrl.text.trim();
                                exam.type = selectedType;
                                exam.office = selectedOffice;
                                exam.startAt = startAt;
                                exam.dueAt = dueAt;
                              }
                            });
                            Navigator.pop(ctx);
                            _snack(exam == null
                                ? 'Exam created'
                                : 'Exam updated');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            exam == null ? 'Create' : 'Save',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Assign office dialog ──────────────────────────────────────────────────

  void _showAssignOfficeDialog(ExamEntry exam) {
    String selected = exam.office;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.business_outlined,
                          color: kGreen, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text('Assign Office',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: kGreenDark)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.grey),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ..._offices.map((o) => RadioListTile<String>(
                      value: o,
                      groupValue: selected,
                      activeColor: kGreen,
                      title: Text(o,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      onChanged: (v) => setDlg(() => selected = v!),
                    )),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => exam.office = selected);
                      Navigator.pop(ctx);
                      _snack('Office assigned: $selected');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Assign',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Add lecture video dialog ──────────────────────────────────────────────

  void _showLectureDialog(ExamEntry exam) {
    final urlCtrl = TextEditingController(text: exam.lectureVideoUrl ?? '');
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.video_library_outlined,
                        color: kGold, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text('Add Lecture Video',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: kGreenDark)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Add lecture materials examinees must review before taking this exam.',
                style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: urlCtrl,
                decoration: _fieldDeco('Video URL', Icons.link_rounded),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                readOnly: true,
                onTap: () {},
                decoration: _fieldDeco('PDF Lecture', Icons.picture_as_pdf_outlined)
                    .copyWith(
                  suffixIcon: Icon(Icons.upload_file_rounded,
                      color: kGreen.withOpacity(0.8), size: 22),
                  hintText: 'Tap to upload PDF',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Upload a PDF file for examinees to read before the exam.',
                style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (exam.lectureVideoUrl != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() => exam.lectureVideoUrl = null);
                          Navigator.pop(ctx);
                          _snack('Lecture video removed');
                        },
                        icon: Icon(Icons.delete_outline,
                            color: Colors.red.shade400, size: 18),
                        label: Text('Remove',
                            style: TextStyle(color: Colors.red.shade400)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.red.shade200),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  if (exam.lectureVideoUrl != null) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() =>
                            exam.lectureVideoUrl = urlCtrl.text.trim().isEmpty
                                ? null
                                : urlCtrl.text.trim());
                        Navigator.pop(ctx);
                        _snack('Lecture video saved');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Delete confirm ────────────────────────────────────────────────────────

  void _confirmDelete(ExamEntry exam) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.red.shade50, shape: BoxShape.circle),
                child: Icon(Icons.delete_outline_rounded,
                    color: Colors.red.shade400, size: 32),
              ),
              const SizedBox(height: 16),
              const Text('Delete Exam',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Delete "${exam.title}"? This cannot be undone.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.grey, height: 1.5)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _exams.remove(exam));
                        Navigator.pop(ctx);
                        _snack('Exam deleted');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Delete',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: kGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  InputDecoration _fieldDeco(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kGreen, size: 20),
        filled: true,
        fillColor: const Color(0xFFF4F6F9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kGreen, width: 1.8)),
      );

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Examination Management',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: kGreenDark)),
                    SizedBox(height: 3),
                    Text('Create, edit and manage office exams',
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showExamDialog(),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Create Exam',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: _exams.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.quiz_outlined,
                          size: 56, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text('No exams yet',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 15)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _exams.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _ExamCard(
                    exam: _exams[i],
                    typeColor: _typeColors[
                        _types.indexOf(_exams[i].type).clamp(0, 2)],
                    onEdit: () => _showExamDialog(exam: _exams[i]),
                    onDelete: () => _confirmDelete(_exams[i]),
                    onAssignOffice: () => _showAssignOfficeDialog(_exams[i]),
                    onAddLecture: () => _showLectureDialog(_exams[i]),
                    onViewHistory: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExamHistoryPage(filterExam: _exams[i].title),
                      ),
                    ),
                  ),                ),
        ),
      ],
    );
  }
}

// ── Schedule helpers ──────────────────────────────────────────────────────────

String _scheduleLabel(ExamEntry exam) {
  String short(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour >= 12 ? 'PM' : 'AM';
    return 'May ${dt.day} $h:$m $p';
  }

  return '${short(exam.startAt)} – ${short(exam.dueAt)}';
}

class _ScheduleField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const _ScheduleField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kGreen, size: 20),
        suffixIcon: const Icon(Icons.calendar_month_rounded,
            color: kGreen, size: 20),
        filled: true,
        fillColor: const Color(0xFFF4F6F9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kGreen, width: 1.8)),
      ),
    );
  }
}

// ── Exam card ─────────────────────────────────────────────────────────────────

class _ExamCard extends StatelessWidget {
  final ExamEntry exam;
  final Color typeColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAssignOffice;
  final VoidCallback onAddLecture;
  final VoidCallback onViewHistory;

  const _ExamCard({
    required this.exam,
    required this.typeColor,
    required this.onEdit,
    required this.onDelete,
    required this.onAssignOffice,
    required this.onAddLecture,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.quiz_rounded, color: typeColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exam.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _Pill(label: exam.type, color: typeColor),
                        const SizedBox(width: 6),
                        _Pill(
                            label: exam.office,
                            color: kGreenDark),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: Colors.grey, size: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                  if (v == 'office') onAssignOffice();
                  if (v == 'lecture') onAddLecture();
                  if (v == 'history') onViewHistory();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 10),
                        Text('Edit Exam'),
                      ])),
                  const PopupMenuItem(
                      value: 'office',
                      child: Row(children: [
                        Icon(Icons.business_outlined, size: 18),
                        SizedBox(width: 10),
                        Text('Assign Office'),
                      ])),
                  const PopupMenuItem(
                      value: 'lecture',
                      child: Row(children: [
                        Icon(Icons.video_library_outlined,
                            size: 18, color: kGold),
                        SizedBox(width: 10),
                        Text('Add Lecture Video'),
                      ])),
                  const PopupMenuItem(
                      value: 'history',
                      child: Row(children: [
                        Icon(Icons.history_rounded,
                            size: 18, color: Color(0xFF5B8DD9)),
                        SizedBox(width: 10),
                        Text('View History'),
                      ])),
                  PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_outline,
                            size: 18, color: Colors.red.shade400),
                        const SizedBox(width: 10),
                        Text('Delete',
                            style:
                                TextStyle(color: Colors.red.shade400)),
                      ])),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 0.6),
          const SizedBox(height: 12),

          // action buttons row
          Row(
            children: [
              _ActionBtn(
                icon: Icons.business_outlined,
                label: 'Assign Office',
                color: kGreenDark,
                onTap: onAssignOffice,
              ),
              const SizedBox(width: 8),
              _ActionBtn(
                icon: Icons.video_library_outlined,
                label: exam.lectureVideoUrl != null
                    ? 'Lecture Added ✓'
                    : 'Add Lecture',
                color: exam.lectureVideoUrl != null ? kGold : Colors.grey,
                onTap: onAddLecture,
              ),
              const SizedBox(width: 8),
              _ActionBtn(
                icon: Icons.history_rounded,
                label: 'History',
                color: const Color(0xFF5B8DD9),
                onTap: onViewHistory,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // meta row
          Row(
            children: [
              _MetaPill(
                  icon: Icons.schedule_rounded,
                  label: _scheduleLabel(exam)),
              const SizedBox(width: 8),
              _MetaPill(
                  icon: Icons.help_outline_rounded,
                  label: '${exam.questionCount} items'),
            ],
          ),

          // recent takers preview
          _TakersPreview(examTitle: exam.title, onViewAll: onViewHistory),
        ],
      ),
    );
  }
}

class _TakersPreview extends StatelessWidget {
  final String examTitle;
  final VoidCallback onViewAll;
  const _TakersPreview({required this.examTitle, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final takers = examTakersMap[examTitle] ?? [];
    if (takers.isEmpty) return const SizedBox.shrink();

    final preview = takers.take(3).toList();
    final extra = takers.length - preview.length;

    String _fmt(DateTime dt) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final p = dt.hour >= 12 ? 'PM' : 'AM';
      return 'May ${dt.day}  $h:$m $p';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 0.6),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.people_outline_rounded, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Text('${takers.length} taker${takers.length == 1 ? '' : 's'}',
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
            const Spacer(),
            if (extra > 0)
              GestureDetector(
                onTap: onViewAll,
                child: Text('+$extra more',
                    style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF5B8DD9),
                        fontWeight: FontWeight.w600)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...preview.map((a) {
          final color = a.passed ? kGreen : Colors.red.shade400;
          return Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(
              children: [
                // avatar initial
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color.withOpacity(0.15),
                  child: Text(
                    a.userName[0].toUpperCase(),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color),
                  ),
                ),
                const SizedBox(width: 10),
                // name
                Expanded(
                  child: Text(a.userName,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                ),
                // date
                Text(_fmt(a.takenAt),
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(width: 10),
                // score badge — score/total only, no percentage
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${a.score}/${a.total}',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: color)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.grey),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
