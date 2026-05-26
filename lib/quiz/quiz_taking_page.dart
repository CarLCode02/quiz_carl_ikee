// The actual quiz screen where users answer questions.
// Supports all 3 types: Multiple Choice, Enumeration, Fill in the Blank.
// After answering all questions, pressing Submit goes to the results page.

import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'quiz_result_page.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

class QuizTakingPage extends StatefulWidget {
  final Exam exam;
  const QuizTakingPage({super.key, required this.exam});

  @override
  State<QuizTakingPage> createState() => _QuizTakingPageState();
}

class _QuizTakingPageState extends State<QuizTakingPage> {
  // Which question the user is currently on (0-based index)
  int _currentIndex = 0;

  // Stores the user's answer for each question
  // Key = question id, Value = the answer (varies by type)
  final Map<String, dynamic> _answers = {};

  // Text controllers for fill-in-the-blank and enumeration inputs
  final Map<String, TextEditingController> _textControllers = {};

  @override
  void initState() {
    super.initState();
    // Create a text controller for every question that needs typing
    for (final q in widget.exam.questions) {
      if (q.type == QuizType.fillInTheBlank) {
        _textControllers[q.id] = TextEditingController();
      }
      if (q.type == QuizType.enumeration) {
        // One controller per expected answer
        for (int i = 0; i < q.enumerationAnswers.length; i++) {
          _textControllers['${q.id}_$i'] = TextEditingController();
        }
      }
    }
  }

  @override
  void dispose() {
    // Always clean up text controllers
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // The question currently on screen
  Question get _currentQuestion =>
      widget.exam.questions[_currentIndex];

  // How many questions are in this exam
  int get _total => widget.exam.questions.length;

  // Move to the next question, or submit if on the last one
  void _next() {
    if (_currentIndex < _total - 1) {
      setState(() => _currentIndex++);
    } else {
      _submit();
    }
  }

  // Move back to the previous question
  void _previous() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  // Calculate the score and go to the results page
  void _submit() {
    int correct = 0;

    for (final q in widget.exam.questions) {
      final answer = _answers[q.id];

      if (q.type == QuizType.multipleChoice) {
        // Check if the selected choice index matches the correct one
        if (answer == q.correctChoiceIndex) correct++;

      } else if (q.type == QuizType.fillInTheBlank) {
        // Case-insensitive comparison
        final typed = _textControllers[q.id]?.text.trim().toLowerCase() ?? '';
        if (typed == q.blankAnswer.toLowerCase()) correct++;

      } else if (q.type == QuizType.enumeration) {
        // Check each answer in order
        bool allCorrect = true;
        for (int i = 0; i < q.enumerationAnswers.length; i++) {
          final typed =
              _textControllers['${q.id}_$i']?.text.trim().toLowerCase() ?? '';
          if (typed != q.enumerationAnswers[i].toLowerCase()) {
            allCorrect = false;
            break;
          }
        }
        if (allCorrect) correct++;
      }
    }

    // Build the result object
    final result = QuizResult(
      examId: widget.exam.id,
      examTitle: widget.exam.title,
      totalQuestions: _total,
      correctAnswers: correct,
      takenAt: DateTime.now(),
      questions: widget.exam.questions,
      userAnswers: {
        // merge selected answers + text controller values
        ..._answers,
        for (final entry in _textControllers.entries)
          entry.key: entry.value.text.trim(),
      },
    );

    // Go to results — replace this page so user can't go back to the quiz
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => QuizResultPage(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _currentQuestion;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: kGreenDark,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.exam.title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
        ),
        actions: [
          // Show current question number in the top right
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentIndex + 1} / $_total',
                style: const TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar at the top
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _total,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(kGold),
            minHeight: 5,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question number label
                  Text(
                    'Question ${_currentIndex + 1}',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  // Question text
                  Text(
                    q.text,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kGreenDark,
                        height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // Show the right input based on question type
                  if (q.type == QuizType.multipleChoice)
                    _MultipleChoiceInput(
                      question: q,
                      selectedIndex: _answers[q.id] as int?,
                      onSelect: (i) =>
                          setState(() => _answers[q.id] = i),
                    ),

                  if (q.type == QuizType.fillInTheBlank)
                    _FillInTheBlankInput(
                      controller: _textControllers[q.id]!,
                    ),

                  if (q.type == QuizType.enumeration)
                    _EnumerationInput(
                      question: q,
                      controllers: _textControllers,
                    ),
                ],
              ),
            ),
          ),

          // Bottom navigation buttons
          _BottomNav(
            currentIndex: _currentIndex,
            total: _total,
            onPrevious: _previous,
            onNext: _next,
          ),
        ],
      ),
    );
  }
}

// ── Multiple choice input ─────────────────────────────────────────────────────

class _MultipleChoiceInput extends StatelessWidget {
  final Question question;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const _MultipleChoiceInput({
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.choices.asMap().entries.map((entry) {
        final i = entry.key;
        final choice = entry.value;
        final isSelected = selectedIndex == i;

        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? kGreen.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? kGreen : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Letter label: A, B, C, D
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? kGreen : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + i), // A=65, B=66...
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    choice,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected ? kGreenDark : Colors.black87,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded,
                      color: kGreen, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Fill in the blank input ───────────────────────────────────────────────────

class _FillInTheBlankInput extends StatelessWidget {
  final TextEditingController controller;
  const _FillInTheBlankInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Type your answer here...',
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kGreen, width: 2),
        ),
      ),
    );
  }
}

// ── Enumeration input ─────────────────────────────────────────────────────────

class _EnumerationInput extends StatelessWidget {
  final Question question;
  final Map<String, TextEditingController> controllers;
  const _EnumerationInput(
      {required this.question, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        question.enumerationAnswers.length,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // Number label
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                        color: kGreen, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controllers['${question.id}_$i'],
                  decoration: InputDecoration(
                    hintText: 'Answer ${i + 1}',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: kGreen, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom navigation bar ─────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final int total;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _BottomNav({
    required this.currentIndex,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentIndex == total - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button — hidden on first question
          if (currentIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPrevious,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          if (currentIndex > 0) const SizedBox(width: 12),

          // Next or Submit button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: Icon(
                isLast
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_rounded,
                size: 18,
              ),
              label: Text(isLast ? 'Submit Quiz' : 'Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLast ? kGold : kGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
