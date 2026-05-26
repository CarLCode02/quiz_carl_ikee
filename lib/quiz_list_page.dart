import 'package:flutter/material.dart';
import 'package:quizcarl_ikee/profile_page.dart';
import '../models/app_models.dart' as models;
import '../quiz/lecture_page.dart';

// alias to avoid clash with local QuizType enum
typedef AppQuizType = models.QuizType;
typedef Exam = models.Exam;
final stubExams = models.stubExams;

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);
const Color kGreenLight = Color(0xFF56B87A);

// ── Data models ───────────────────────────────────────────────────────────────

enum QuizType { multipleChoice, enumeration, fillInTheBlank }

extension QuizTypeExt on QuizType {
  String get label {
    switch (this) {
      case QuizType.multipleChoice:   return 'Multiple Choice';
      case QuizType.enumeration:      return 'Enumeration';
      case QuizType.fillInTheBlank:   return 'Fill in the Blank';
    }
  }

  IconData get icon {
    switch (this) {
      case QuizType.multipleChoice:   return Icons.check_circle_outline_rounded;
      case QuizType.enumeration:      return Icons.format_list_numbered_rounded;
      case QuizType.fillInTheBlank:   return Icons.edit_outlined;
    }
  }

  Color get color {
    switch (this) {
      case QuizType.multipleChoice:   return const Color(0xFF3D925F);
      case QuizType.enumeration:      return const Color(0xFFE7AB38);
      case QuizType.fillInTheBlank:   return const Color(0xFF5B8DD9);
    }
  }
}

class QuizItem {
  final String title;
  final String office;
  final QuizType type;
  final DateTime dateTime;
  final int questionCount;

  const QuizItem({
    required this.title,
    required this.office,
    required this.type,
    required this.dateTime,
    required this.questionCount,
  });
}

// ── Stub data ─────────────────────────────────────────────────────────────────

final _stubQuizzes = [
  QuizItem(title: 'Hospital Safety Protocols',    office: 'Opthalmology',         type: QuizType.multipleChoice,  dateTime: DateTime(2026, 5, 1, 9, 0),   questionCount: 20),
  QuizItem(title: 'Medical Equipment Essentials', office: 'Hospital Essentials', type: QuizType.enumeration,     dateTime: DateTime(2026, 5, 2, 10, 30), questionCount: 15),
  QuizItem(title: 'Patient Care Procedures',      office: 'Hospital Essentials', type: QuizType.fillInTheBlank,  dateTime: DateTime(2026, 5, 3, 14, 0),  questionCount: 10),
  QuizItem(title: 'Midterm — Unit 1',             office: 'Midterm Exam',        type: QuizType.multipleChoice,  dateTime: DateTime(2026, 5, 5, 8, 0),   questionCount: 50),
  QuizItem(title: 'Midterm — Unit 2',             office: 'Midterm Exam',        type: QuizType.enumeration,     dateTime: DateTime(2026, 5, 6, 8, 0),   questionCount: 30),
];// ── Page ──────────────────────────────────────────────────────────────────────

class QuizListPage extends StatefulWidget {
  const QuizListPage({super.key});

  @override
  State<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage>
    with SingleTickerProviderStateMixin {
  String? _selectedOffice;
  QuizType? _selectedType;

  AnimationController? _ctrl;
  Animation<double>? _fade;
  Animation<Offset>? _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl!, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl!, curve: Curves.easeOut));
    _ctrl!.forward();
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  List<String> get _offices {
    final o = _stubQuizzes.map((q) => q.office).toSet().toList()..sort();
    return o;
  }

  List<QuizItem> get _filtered => _stubQuizzes.where((q) {
        final om = _selectedOffice == null || q.office == _selectedOffice;
        final tm = _selectedType == null || q.type == _selectedType;
        return om && tm;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: CustomScrollView(
        slivers: [
          // ── App bar ───────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: kGreenDark,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kGreenDark, kGreen, kGreenLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40, right: -40,
                    child: Container(width: 160, height: 160,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Available Quizzes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('${_filtered.length} quiz${_filtered.length == 1 ? '' : 'zes'} found',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Filter chips ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Office filter
                  const Text('Office',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          selected: _selectedOffice == null,
                          onTap: () =>
                              setState(() => _selectedOffice = null),
                        ),
                        ..._offices.map((o) => _FilterChip(
                              label: o,
                              selected: _selectedOffice == o,
                              onTap: () =>
                                  setState(() => _selectedOffice = o),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Type filter
                  const Text('Exam Type',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          selected: _selectedType == null,
                          onTap: () =>
                              setState(() => _selectedType = null),
                        ),
                        ...QuizType.values.map((t) => _FilterChip(
                              label: t.label,
                              selected: _selectedType == t,
                              color: t.color,
                              onTap: () =>
                                  setState(() => _selectedType = t),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
              child: SizedBox(height: 12)),

          // ── Quiz cards ────────────────────────────────────────────────
          _filtered.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 56, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No quizzes found',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final fade = _fade;
                        final slide = _slide;
                        final card = Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _QuizCard(quiz: _filtered[i]),
                        );
                        if (fade == null || slide == null) return card;
                        return FadeTransition(
                          opacity: fade,
                          child: SlideTransition(
                            position: slide,
                            child: card,
                          ),
                        );
                      },
                      childCount: _filtered.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? kGreen;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? c : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? c : Colors.grey.shade300, width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}

// ── Quiz card ─────────────────────────────────────────────────────────────────

class _QuizCard extends StatelessWidget {
  final QuizItem quiz;
  const _QuizCard({required this.quiz});

  String _pad(int n) => n.toString().padLeft(2, '0');

  String get _date =>
      '${_pad(quiz.dateTime.month)}/${_pad(quiz.dateTime.day)}/${quiz.dateTime.year}';

  String get _time {
    final h = quiz.dateTime.hour;
    final m = _pad(quiz.dateTime.minute);
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h % 12 == 0 ? 12 : h % 12;
    return '$hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = quiz.type.color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Card header ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.07),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(quiz.type.icon, color: typeColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    quiz.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                // type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(quiz.type.label,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: typeColor)),
                ),
              ],
            ),
          ),

          // ── Card body ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    _InfoPill(
                        icon: Icons.business_outlined,
                        label: quiz.office,
                        color: kGreen),
                    const SizedBox(width: 8),
                    _InfoPill(
                        icon: Icons.help_outline_rounded,
                        label: '${quiz.questionCount} items',
                        color: kGreenDark),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(_date,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time_rounded,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(_time,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Use first stub exam as demo — in real app match by id
                      final exam = stubExams.isNotEmpty
                          ? stubExams[0]
                          : Exam(
                              id: '0',
                              title: quiz.title,
                              office: quiz.office,
                              type: AppQuizType.multipleChoice,
                              scheduledAt: quiz.dateTime,
                              questions: const [],
                            );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LecturePage(exam: exam),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Take Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info pill ─────────────────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoPill(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }
}
