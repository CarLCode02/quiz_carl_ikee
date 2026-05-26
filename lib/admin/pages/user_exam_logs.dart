import 'package:flutter/material.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

// ── Model ─────────────────────────────────────────────────────────────────────

class ExamAttempt {
  final String userName;
  final String userEmail;
  final String examTitle;
  final String office;
  final int score;
  final int total;
  final DateTime takenAt;

  const ExamAttempt({
    required this.userName,
    required this.userEmail,
    required this.examTitle,
    required this.office,
    required this.score,
    required this.total,
    required this.takenAt,
  });

  double get percent => total == 0 ? 0 : (score / total) * 100;
  bool get passed => percent >= 75;
}

// ── Hardcoded data per exam ───────────────────────────────────────────────────
// Key = exact exam title, Value = list of attempts

final Map<String, List<ExamAttempt>> examTakersMap = {
  'Exam 1: Office Procedures': [
    ExamAttempt(userName: 'Juan Dela Cruz',    userEmail: 'juan@brghgmc.com',    examTitle: 'Exam 1: Office Procedures', office: 'Internal Medicine', score: 17, total: 20, takenAt: DateTime(2026, 5, 1, 9, 14)),
    ExamAttempt(userName: 'Maria Santos',      userEmail: 'maria@brghgmc.com',   examTitle: 'Exam 1: Office Procedures', office: 'Internal Medicine', score: 14, total: 20, takenAt: DateTime(2026, 5, 1, 10, 3)),
    ExamAttempt(userName: 'pony mo',        userEmail: 'jose@brghgmc.com',    examTitle: 'Exam 1: Office Procedures', office: 'Internal Medicine', score: 9,  total: 20, takenAt: DateTime(2026, 5, 1, 11, 45)),
    ExamAttempt(userName: 'Basilio Cruz',      userEmail: 'basilio@brghgmc.com', examTitle: 'Exam 1: Office Procedures', office: 'Internal Medicine', score: 20, total: 20, takenAt: DateTime(2026, 5, 1, 13, 0)),
  ],
  'Exam 2: Office Procedures': [
    ExamAttempt(userName: 'Juan Dela Cruz',    userEmail: 'juan@brghgmc.com',    examTitle: 'Exam 2: Office Procedures', office: 'Hospital Essentials', score: 12, total: 20, takenAt: DateTime(2026, 5, 2, 9, 30)),
    ExamAttempt(userName: 'Basilio Cruz',      userEmail: 'basilio@brghgmc.com', examTitle: 'Exam 2: Office Procedures', office: 'Hospital Essentials', score: 18, total: 20, takenAt: DateTime(2026, 5, 2, 10, 0)),
    ExamAttempt(userName: 'Sisa Maranion',     userEmail: 'sisa@brghgmc.com',    examTitle: 'Exam 2: Office Procedures', office: 'Hospital Essentials', score: 15, total: 20, takenAt: DateTime(2026, 5, 2, 11, 20)),
  ],
  'Exam 3: Office Procedures': [
    ExamAttempt(userName: 'Ana Gonzales',      userEmail: 'ana@brghgmc.com',     examTitle: 'Exam 3: Office Procedures', office: 'Midterm Exam', score: 7,  total: 20, takenAt: DateTime(2026, 5, 3, 14, 22)),
    ExamAttempt(userName: 'Sisa Maranion',     userEmail: 'sisa@brghgmc.com',    examTitle: 'Exam 3: Office Procedures', office: 'Midterm Exam', score: 16, total: 20, takenAt: DateTime(2026, 5, 3, 15, 5)),
    ExamAttempt(userName: 'Pedro Reyes',       userEmail: 'pedro@brghgmc.com',   examTitle: 'Exam 3: Office Procedures', office: 'Midterm Exam', score: 19, total: 20, takenAt: DateTime(2026, 5, 3, 15, 40)),
  ],
  'Exam 4: Office Procedures': [
    ExamAttempt(userName: 'Crisostomo Ibarra', userEmail: 'cris@brghgmc.com',    examTitle: 'Exam 4: Office Procedures', office: 'Internal Medicine', score: 13, total: 20, takenAt: DateTime(2026, 5, 4, 8, 47)),
    ExamAttempt(userName: 'Pedro Reyes',       userEmail: 'pedro@brghgmc.com',   examTitle: 'Exam 4: Office Procedures', office: 'Internal Medicine', score: 17, total: 20, takenAt: DateTime(2026, 5, 4, 9, 10)),
  ],
  'Exam 5: Office Procedures': [
    ExamAttempt(userName: 'Maria Santos',      userEmail: 'maria@brghgmc.com',   examTitle: 'Exam 5: Office Procedures', office: 'Hospital Essentials', score: 11, total: 20, takenAt: DateTime(2026, 5, 5, 8, 55)),
    ExamAttempt(userName: 'Juan Dela Cruz',    userEmail: 'juan@brghgmc.com',    examTitle: 'Exam 5: Office Procedures', office: 'Hospital Essentials', score: 20, total: 20, takenAt: DateTime(2026, 5, 5, 9, 30)),
    ExamAttempt(userName: 'Ana Gonzales',      userEmail: 'ana@brghgmc.com',     examTitle: 'Exam 5: Office Procedures', office: 'Hospital Essentials', score: 16, total: 20, takenAt: DateTime(2026, 5, 5, 10, 10)),
  ],
  'Exam 6: Office Procedures': [
    ExamAttempt(userName: 'pony mo',        userEmail: 'jose@brghgmc.com',    examTitle: 'Exam 6: Office Procedures', office: 'Midterm Exam', score: 14, total: 20, takenAt: DateTime(2026, 5, 6, 10, 15)),
    ExamAttempt(userName: 'Ana Gonzales',      userEmail: 'ana@brghgmc.com',     examTitle: 'Exam 6: Office Procedures', office: 'Midterm Exam', score: 18, total: 20, takenAt: DateTime(2026, 5, 6, 11, 0)),
  ],
};

// ── Hardcoded data per user ───────────────────────────────────────────────────

final Map<String, List<ExamAttempt>> userHistoryMap = {
  'Juan Dela Cruz': [
    ExamAttempt(userName: 'Juan Dela Cruz', userEmail: 'juan@brghgmc.com', examTitle: 'Exam 1: Office Procedures', office: 'Internal Medicine',          score: 17, total: 20, takenAt: DateTime(2026, 5, 1, 9, 14)),
    ExamAttempt(userName: 'Juan Dela Cruz', userEmail: 'juan@brghgmc.com', examTitle: 'Exam 2: Office Procedures', office: 'Hospital Essentials', score: 12, total: 20, takenAt: DateTime(2026, 5, 2, 9, 30)),
    ExamAttempt(userName: 'Juan Dela Cruz', userEmail: 'juan@brghgmc.com', examTitle: 'Exam 5: Office Procedures', office: 'Hospital Essentials', score: 20, total: 20, takenAt: DateTime(2026, 5, 5, 9, 30)),
  ],
  'Maria Santos': [
    ExamAttempt(userName: 'Maria Santos', userEmail: 'maria@brghgmc.com', examTitle: 'Exam 1: Office Procedures', office: 'Internal Medicine',          score: 14, total: 20, takenAt: DateTime(2026, 5, 1, 10, 3)),
    ExamAttempt(userName: 'Maria Santos', userEmail: 'maria@brghgmc.com', examTitle: 'Exam 5: Office Procedures', office: 'Hospital Essentials', score: 11, total: 20, takenAt: DateTime(2026, 5, 5, 8, 55)),
  ],
  'Pedro Reyes': [
    ExamAttempt(userName: 'Pedro Reyes', userEmail: 'pedro@brghgmc.com', examTitle: 'Exam 3: Office Procedures', office: 'Midterm Exam', score: 19, total: 20, takenAt: DateTime(2026, 5, 3, 15, 40)),
    ExamAttempt(userName: 'Pedro Reyes', userEmail: 'pedro@brghgmc.com', examTitle: 'Exam 4: Office Procedures', office: 'Internal Medicine',   score: 17, total: 20, takenAt: DateTime(2026, 5, 4, 9, 10)),
  ],
  'Ana Gonzales': [
    ExamAttempt(userName: 'Ana Gonzales', userEmail: 'ana@brghgmc.com', examTitle: 'Exam 3: Office Procedures', office: 'Midterm Exam',        score: 7,  total: 20, takenAt: DateTime(2026, 5, 3, 14, 22)),
    ExamAttempt(userName: 'Ana Gonzales', userEmail: 'ana@brghgmc.com', examTitle: 'Exam 5: Office Procedures', office: 'Hospital Essentials', score: 16, total: 20, takenAt: DateTime(2026, 5, 5, 10, 10)),
    ExamAttempt(userName: 'Ana Gonzales', userEmail: 'ana@brghgmc.com', examTitle: 'Exam 6: Office Procedures', office: 'Midterm Exam',        score: 18, total: 20, takenAt: DateTime(2026, 5, 6, 11, 0)),
  ],
  'pony mo': [
    ExamAttempt(userName: 'pony mo', userEmail: 'jose@brghgmc.com', examTitle: 'Exam 1: Office Procedures', office: 'Internal Medicine',   score: 9,  total: 20, takenAt: DateTime(2026, 5, 1, 11, 45)),
    ExamAttempt(userName: 'pony mo', userEmail: 'jose@brghgmc.com', examTitle: 'Exam 6: Office Procedures', office: 'Midterm Exam', score: 14, total: 20, takenAt: DateTime(2026, 5, 6, 10, 15)),
  ],
  'Crisostomo Ibarra': [
    ExamAttempt(userName: 'Crisostomo Ibarra', userEmail: 'cris@brghgmc.com', examTitle: 'Exam 4: Office Procedures', office: 'Internal Medicine', score: 13, total: 20, takenAt: DateTime(2026, 5, 4, 8, 47)),
  ],
  'Sisa Maranion': [
    ExamAttempt(userName: 'Sisa Maranion', userEmail: 'sisa@brghgmc.com', examTitle: 'Exam 2: Office Procedures', office: 'Hospital Essentials', score: 15, total: 20, takenAt: DateTime(2026, 5, 2, 11, 20)),
    ExamAttempt(userName: 'Sisa Maranion', userEmail: 'sisa@brghgmc.com', examTitle: 'Exam 3: Office Procedures', office: 'Midterm Exam',        score: 16, total: 20, takenAt: DateTime(2026, 5, 3, 15, 5)),
  ],
  'Basilio Cruz': [
    ExamAttempt(userName: 'Basilio Cruz', userEmail: 'basilio@brghgmc.com', examTitle: 'Exam 1: Office Procedures', office: 'Internal Medicine',          score: 20, total: 20, takenAt: DateTime(2026, 5, 1, 13, 0)),
    ExamAttempt(userName: 'Basilio Cruz', userEmail: 'basilio@brghgmc.com', examTitle: 'Exam 2: Office Procedures', office: 'Hospital Essentials', score: 18, total: 20, takenAt: DateTime(2026, 5, 2, 10, 0)),
  ],
};

// ── Page ──────────────────────────────────────────────────────────────────────

class ExamHistoryPage extends StatelessWidget {
  final String? filterExam;
  final String? filterUser;

  const ExamHistoryPage({super.key, this.filterExam, this.filterUser});

  String get _title => filterUser != null ? 'User History' : 'Exam History';

  String get _subtitle =>
      filterExam ?? filterUser ?? 'All attempts';

  List<ExamAttempt> get _attempts {
    if (filterExam != null) {
      return examTakersMap[filterExam] ?? [];
    }
    if (filterUser != null) {
      return userHistoryMap[filterUser] ?? [];
    }
    return examTakersMap.values.expand((e) => e).toList();
  }

  String _fmt(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour >= 12 ? 'PM' : 'AM';
    return 'May ${dt.day}, ${dt.year}  •  $h:$m $p';
  }

  @override
  Widget build(BuildContext context) {
    final attempts = _attempts;
    final passed = attempts.where((a) => a.passed).length;
    final avg = attempts.isEmpty
        ? 0.0
        : attempts.map((a) => a.percent).reduce((x, y) => x + y) /
            attempts.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: kGreenDark,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kGreenDark, kGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(_subtitle,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // summary
                  Row(
                    children: [
                      _StatCard(label: 'Attempts',  value: '${attempts.length}',              icon: Icons.quiz_rounded,         color: kGreen),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Passed',    value: '$passed',                          icon: Icons.check_circle_rounded, color: kGold),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Avg Score', value: '${avg.toStringAsFixed(0)}%',       icon: Icons.bar_chart_rounded,    color: const Color(0xFF5B8DD9)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (attempts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Icon(Icons.history_rounded, size: 56, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('No attempts yet',
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
                        ],
                      ),
                    )
                  else
                    ...attempts.map((a) => _AttemptCard(
                          attempt: a,
                          showExamName: filterUser != null,
                          showUserName: filterExam != null,
                          fmt: _fmt,
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Attempt card ──────────────────────────────────────────────────────────────

class _AttemptCard extends StatelessWidget {
  final ExamAttempt attempt;
  final bool showExamName;
  final bool showUserName;
  final String Function(DateTime) fmt;

  const _AttemptCard({
    required this.attempt,
    required this.showExamName,
    required this.showUserName,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final color = attempt.passed ? kGreen : Colors.red.shade400;
    final pct = attempt.percent.toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          // score circle
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$pct%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
                Text(attempt.passed ? 'PASS' : 'FAIL',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showUserName)
                  Text(attempt.userName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                if (showExamName)
                  Text(attempt.examTitle,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGreenDark)),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.business_outlined, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(attempt.office, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ]),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.access_time_rounded, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(fmt(attempt.takenAt), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ]),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text('${attempt.score}/${attempt.total}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
          ),
        ],
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
