import 'package:flutter/material.dart';
import '../models/app_models.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

class QuizResultPage extends StatelessWidget {
  final QuizResult result;
  const QuizResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final passed = result.passed;
    final scoreColor = passed ? kGreen : Colors.red.shade400;
    final scorePercent = result.scorePercent.toStringAsFixed(0);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: kGreenDark,
        automaticallyImplyLeading: false,
        title: const Text('Quiz Results',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Score circle
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scoreColor.withOpacity(0.1),
                border: Border.all(color: scoreColor, width: 4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$scorePercent%',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: scoreColor)),
                  Text(
                    passed ? 'PASSED' : 'FAILED',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: scoreColor,
                        letterSpacing: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(result.examTitle,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: kGreenDark),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
              passed
                  ? 'Congratulations! You passed the exam.'
                  : 'You did not reach the passing score of 75%.',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // Score breakdown
            _ResultCard(
              child: Column(
                children: [
                  _ResultRow(
                      icon: Icons.help_outline_rounded,
                      label: 'Total Questions',
                      value: '${result.totalQuestions}',
                      color: Colors.grey),
                  const Divider(height: 20, thickness: 0.7),
                  _ResultRow(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'Correct Answers',
                      value: '${result.correctAnswers}',
                      color: kGreen),
                  const Divider(height: 20, thickness: 0.7),
                  _ResultRow(
                      icon: Icons.cancel_outlined,
                      label: 'Wrong Answers',
                      value: '${result.totalQuestions - result.correctAnswers}',
                      color: Colors.red.shade400),
                  const Divider(height: 20, thickness: 0.7),
                  _ResultRow(
                      icon: Icons.emoji_events_outlined,
                      label: 'Score',
                      value: '$scorePercent%',
                      color: scoreColor),
                  const Divider(height: 20, thickness: 0.7),
                  _ResultRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date Taken',
                      value:
                          '${result.takenAt.month}/${result.takenAt.day}/${result.takenAt.year}',
                      color: Colors.grey),
                ],
              ),
            ),

            // Answer review — only shown if questions were passed
            if (result.questions.isNotEmpty) ...[
              const SizedBox(height: 28),
              _AnswerReview(result: result),
            ],

            const SizedBox(height: 28),

            // Back to quiz list
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.popUntil(
                  context,
                  (route) =>
                      route.isFirst || route.settings.name == '/quizzes',
                ),
                icon: const Icon(Icons.list_rounded, size: 20),
                label: const Text('Back to Quiz List',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                icon: const Icon(Icons.home_rounded, size: 20),
                label: const Text('Go to Home',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Answer review section ─────────────────────────────────────────────────────

class _AnswerReview extends StatelessWidget {
  final QuizResult result;
  const _AnswerReview({required this.result});

  bool _isCorrect(Question q) {
    final answers = result.userAnswers;
    if (q.type == QuizType.multipleChoice) {
      return answers[q.id] == q.correctChoiceIndex;
    } else if (q.type == QuizType.fillInTheBlank) {
      final typed = (answers[q.id] as String? ?? '').toLowerCase();
      return typed == q.blankAnswer.toLowerCase();
    } else if (q.type == QuizType.enumeration) {
      for (int i = 0; i < q.enumerationAnswers.length; i++) {
        final typed =
            (answers['${q.id}_$i'] as String? ?? '').toLowerCase();
        if (typed != q.enumerationAnswers[i].toLowerCase()) return false;
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // section header
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                  color: kGold, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 10),
            const Text('Answer Review',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: kGreenDark)),
          ],
        ),
        const SizedBox(height: 14),
        ...result.questions.asMap().entries.map(
              (e) => _QuestionReviewCard(
                index: e.key,
                question: e.value,
                isCorrect: _isCorrect(e.value),
                userAnswers: result.userAnswers,
              ),
            ),
      ],
    );
  }
}

class _QuestionReviewCard extends StatelessWidget {
  final int index;
  final Question question;
  final bool isCorrect;
  final Map<String, dynamic> userAnswers;

  const _QuestionReviewCard({
    required this.index,
    required this.question,
    required this.isCorrect,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isCorrect ? kGreen : Colors.red.shade400;
    final bgColor =
        isCorrect ? kGreen.withOpacity(0.04) : Colors.red.withOpacity(0.04);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // question header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor.withOpacity(0.3)),
                ),
                child: Text('Q${index + 1}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: borderColor)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(question.text,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kGreenDark,
                        height: 1.4)),
              ),
              const SizedBox(width: 8),
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: borderColor,
                size: 22,
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 0.6),
          const SizedBox(height: 12),

          // per-type answer display
          if (question.type == QuizType.multipleChoice)
            _MultipleChoiceReview(
                question: question,
                selectedIndex: userAnswers[question.id] as int?),

          if (question.type == QuizType.fillInTheBlank)
            _FillBlankReview(
                question: question,
                typed: userAnswers[question.id] as String? ?? ''),

          if (question.type == QuizType.enumeration)
            _EnumerationReview(
                question: question, userAnswers: userAnswers),
        ],
      ),
    );
  }
}

// Multiple choice review
class _MultipleChoiceReview extends StatelessWidget {
  final Question question;
  final int? selectedIndex;
  const _MultipleChoiceReview(
      {required this.question, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.choices.asMap().entries.map((e) {
        final i = e.key;
        final choice = e.value;
        final isCorrectChoice = i == question.correctChoiceIndex;
        final isUserChoice = i == selectedIndex;

        Color bg = Colors.grey.shade50;
        Color border = Colors.grey.shade200;
        Color textColor = Colors.black87;
        IconData? trailingIcon;

        if (isCorrectChoice) {
          bg = kGreen.withOpacity(0.08);
          border = kGreen;
          textColor = kGreenDark;
          trailingIcon = Icons.check_circle_rounded;
        }
        if (isUserChoice && !isCorrectChoice) {
          bg = Colors.red.withOpacity(0.07);
          border = Colors.red.shade400;
          textColor = Colors.red.shade700;
          trailingIcon = Icons.cancel_rounded;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCorrectChoice
                      ? kGreen
                      : isUserChoice
                          ? Colors.red.shade400
                          : Colors.grey.shade200,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + i),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: (isCorrectChoice || isUserChoice)
                            ? Colors.white
                            : Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(choice,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: isCorrectChoice || isUserChoice
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: textColor))),
              if (trailingIcon != null)
                Icon(trailingIcon,
                    color: isCorrectChoice ? kGreen : Colors.red.shade400,
                    size: 18),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Fill in the blank review
class _FillBlankReview extends StatelessWidget {
  final Question question;
  final String typed;
  const _FillBlankReview(
      {required this.question, required this.typed});

  @override
  Widget build(BuildContext context) {
    final correct =
        typed.toLowerCase() == question.blankAnswer.toLowerCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AnswerRow(
            label: 'Your answer',
            value: typed.isEmpty ? '(no answer)' : typed,
            color: correct ? kGreen : Colors.red.shade400),
        if (!correct) ...[
          const SizedBox(height: 8),
          _AnswerRow(
              label: 'Correct answer',
              value: question.blankAnswer,
              color: kGreen),
        ],
      ],
    );
  }
}

// Enumeration review
class _EnumerationReview extends StatelessWidget {
  final Question question;
  final Map<String, dynamic> userAnswers;
  const _EnumerationReview(
      {required this.question, required this.userAnswers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(question.enumerationAnswers.length, (i) {
        final typed =
            (userAnswers['${question.id}_$i'] as String? ?? '');
        final correct = question.enumerationAnswers[i];
        final isCorrect =
            typed.toLowerCase() == correct.toLowerCase();

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCorrect
                ? kGreen.withOpacity(0.06)
                : Colors.red.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isCorrect ? kGreen : Colors.red.shade400,
                width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCorrect ? kGreen : Colors.red.shade400,
                ),
                child: Center(
                  child: Text('${i + 1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typed.isEmpty ? '(no answer)' : typed,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isCorrect
                              ? kGreenDark
                              : Colors.red.shade700),
                    ),
                    if (!isCorrect) ...[
                      const SizedBox(height: 3),
                      Text('Correct: $correct',
                          style: const TextStyle(
                              fontSize: 12, color: kGreen)),
                    ],
                  ],
                ),
              ),
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: isCorrect ? kGreen : Colors.red.shade400,
                size: 18,
              ),
            ],
          ),
        );
      }),
    );
  }
}

// Shared answer row widget
class _AnswerRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _AnswerRow(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Expanded(
          child: Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ),
      ],
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final Widget child;
  const _ResultCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _ResultRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
            child: Text(label,
                style:
                    const TextStyle(fontSize: 14, color: Colors.black54))),
        Text(value,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color)),
      ],
    );
  }
}
