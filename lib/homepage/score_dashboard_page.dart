import 'package:flutter/material.dart';
import '../models/app_models.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);
const Color kGreenLight = Color(0xFF56B87A);

// Stub results for display
final _stubResults = [
  QuizResult(
    examId: 'e1',
    examTitle: 'Hospital Safety Protocols',
    totalQuestions: 20,
    correctAnswers: 17,
    takenAt: DateTime(2026, 5, 1),
  ),
  QuizResult(
    examId: 'e2',
    examTitle: 'Medical Equipment Essentials',
    totalQuestions: 15,
    correctAnswers: 10,
    takenAt: DateTime(2026, 5, 2),
  ),
  QuizResult(
    examId: 'e3',
    examTitle: 'Patient Care Procedures',
    totalQuestions: 10,
    correctAnswers: 8,
    takenAt: DateTime(2026, 5, 3),
  ),
];

class ScoreDashboardPage extends StatelessWidget {
  const ScoreDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final total = _stubResults.length;
    final passed = _stubResults.where((r) => r.passed).length;
    final avgScore = _stubResults.isEmpty
        ? 0.0
        : _stubResults.map((r) => r.scorePercent).reduce((a, b) => a + b) /
            total;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: kGreenDark,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kGreenDark, kGreen, kGreenLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Score Dashboard',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text('Your quiz performance overview',
                            style: TextStyle(
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
                  // Summary stats
                  Row(
                    children: [
                      _StatCard(
                          label: 'Quizzes\nTaken',
                          value: '$total',
                          icon: Icons.quiz_rounded,
                          color: kGreen),
                      const SizedBox(width: 12),
                      _StatCard(
                          label: 'Passed',
                          value: '$passed',
                          icon: Icons.check_circle_rounded,
                          color: kGold),
                      const SizedBox(width: 12),
                      _StatCard(
                          label: 'Avg Score',
                          value: '${avgScore.toStringAsFixed(0)}%',
                          icon: Icons.bar_chart_rounded,
                          color: const Color(0xFF5B8DD9)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Results list
                  ..._stubResults.map((r) => _ResultTile(result: r)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11, color: Colors.grey, height: 1.3)),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final QuizResult result;
  const _ResultTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final passed = result.passed;
    final color = passed ? kGreen : Colors.red.shade400;
    final pct = result.scorePercent.toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text('$pct%',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: color)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.examTitle,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                    '${result.correctAnswers}/${result.totalQuestions} correct  •  '
                    '${result.takenAt.month}/${result.takenAt.day}/${result.takenAt.year}',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(passed ? 'PASSED' : 'FAILED',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ),
        ],
      ),
    );
  }
}
