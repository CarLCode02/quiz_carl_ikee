// This page shows the lecture video for an exam before the user takes it.
// After watching, the user can press "Start Quiz" to go to the quiz.

import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'quiz_taking_page.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

class LecturePage extends StatefulWidget {
  final Exam exam;
  const LecturePage({super.key, required this.exam});

  @override
  State<LecturePage> createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  // Tracks whether the user has "watched" the lecture
  // In a real app this would check actual video progress
  bool _lectureWatched = false;

  @override
  Widget build(BuildContext context) {
    final hasLecture = widget.exam.lectureVideoUrl != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: kGreenDark,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.exam.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Exam info card at the top
            _ExamInfoCard(exam: widget.exam),
            const SizedBox(height: 20),

            // Lecture section — only show if there is a video
            if (hasLecture) ...[
              const _SectionLabel(label: 'Watch Lecture First'),
              const SizedBox(height: 12),

              // Video player placeholder
              // Replace this Container with a real video player widget later
              GestureDetector(
                onTap: () {
                  // Simulate finishing the lecture
                  setState(() => _lectureWatched = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lecture marked as watched!'),
                      backgroundColor: kGreen,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _lectureWatched
                            ? Icons.check_circle_rounded
                            : Icons.play_circle_fill_rounded,
                        color: _lectureWatched ? kGold : Colors.white,
                        size: 64,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _lectureWatched
                            ? 'Lecture Watched ✓'
                            : 'Tap to Watch Lecture',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Instructions before starting
            const _SectionLabel(label: 'Before You Start'),
            const SizedBox(height: 12),
            _InstructionCard(exam: widget.exam),
            const SizedBox(height: 28),

            // Start Quiz button
            // If there's a lecture, user must watch it first
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (hasLecture && !_lectureWatched)
                    ? null // disabled until lecture is watched
                    : () {
                        // Go to the actual quiz
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizTakingPage(exam: widget.exam),
                          ),
                        );
                      },
                icon: const Icon(Icons.play_arrow_rounded, size: 22),
                label: Text(
                  (hasLecture && !_lectureWatched)
                      ? 'Watch Lecture to Unlock'
                      : 'Start Quiz',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shows the exam title, office, type, and question count
class _ExamInfoCard extends StatelessWidget {
  final Exam exam;
  const _ExamInfoCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kGreenDark, kGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exam.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: [
              _Chip(icon: Icons.business_outlined, label: exam.office),
              const SizedBox(width: 8),
              _Chip(icon: Icons.quiz_outlined, label: exam.type.label),
              const SizedBox(width: 8),
              _Chip(
                icon: Icons.help_outline_rounded,
                label: '${exam.questions.length} items',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 13),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}

// Shows instructions like time limit, passing score, etc.
class _InstructionCard extends StatelessWidget {
  final Exam exam;
  const _InstructionCard({required this.exam});

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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _InstructionRow(
            icon: Icons.help_outline_rounded,
            label: 'Total Questions',
            value: '${exam.questions.length} items',
          ),
          const Divider(height: 20, thickness: 0.7),
          const _InstructionRow(
            icon: Icons.timer_outlined,
            label: 'Time Limit',
            value: 'No time limit',
          ),
          const Divider(height: 20, thickness: 0.7),
          const _InstructionRow(
            icon: Icons.emoji_events_outlined,
            label: 'Passing Score',
            value: '75%',
          ),
          const Divider(height: 20, thickness: 0.7),
          const _InstructionRow(
            icon: Icons.info_outline_rounded,
            label: 'Note',
            value: 'You can only submit once',
          ),
        ],
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InstructionRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kGreen, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4, height: 18,
          decoration: BoxDecoration(
              color: kGold, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: kGreenDark)),
      ],
    );
  }
}
