// All data models used across the app.
// No database — just plain Dart classes with stub data.

// Who is logged in — admin or regular user
enum UserRole { admin, user }

// The 3 types of quiz questions
enum QuizType { multipleChoice, enumeration, fillInTheBlank }

extension QuizTypeLabel on QuizType {
  String get label {
    switch (this) {
      case QuizType.multipleChoice:  return 'Multiple Choice';
      case QuizType.enumeration:     return 'Enumeration';
      case QuizType.fillInTheBlank:  return 'Fill in the Blank';
    }
  }
}

// A person who can log in (admin or user)
class AppUser {
  final String id;
  final String name;
  final String username;
  final String email;
  final String office;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.office,
    required this.role,
  });
}

// One question inside a quiz
class Question {
  final String id;
  final String text;
  final QuizType type;

  // For multiple choice — the 4 options and which one is correct
  final List<String> choices;
  final int correctChoiceIndex;

  // For enumeration — the list of answers in order
  final List<String> enumerationAnswers;

  // For fill in the blank — the correct word/phrase
  final String blankAnswer;

  const Question({
    required this.id,
    required this.text,
    required this.type,
    this.choices = const [],
    this.correctChoiceIndex = 0,
    this.enumerationAnswers = const [],
    this.blankAnswer = '',
  });
}

// A quiz/exam that users can take
class Exam {
  final String id;
  final String title;
  final String office;
  final QuizType type;
  final DateTime scheduledAt;
  final List<Question> questions;
  final String? lectureVideoUrl; // optional lecture video before the quiz
  bool isActive;

  Exam({
    required this.id,
    required this.title,
    required this.office,
    required this.type,
    required this.scheduledAt,
    required this.questions,
    this.lectureVideoUrl,
    this.isActive = true,
  });
}

// A completed quiz attempt by a user
class QuizResult {
  final String examId;
  final String examTitle;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime takenAt;
  final List<Question> questions;
  final Map<String, dynamic> userAnswers; // key = question id

  const QuizResult({
    required this.examId,
    required this.examTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.takenAt,
    this.questions = const [],
    this.userAnswers = const {},
  });

  // Score as a percentage (0–100)
  double get scorePercent =>
      totalQuestions == 0 ? 0 : (correctAnswers / totalQuestions) * 100;

  // Passed if score is 75% or above
  bool get passed => scorePercent >= 75;
}

// ── Stub data — replace with real API/DB later ────────────────────────────────

// Two test accounts: one admin, one regular user
final stubUsers = [
  const AppUser(
    id: 'u1',
    name: 'Carl Lawrence S. Maranion',
    username: 'admin',
    email: 'admin@brghgmc.com',
    office: 'Internal Medicine',
    role: UserRole.admin,
  ),
  const AppUser(
    id: 'u2',
    name: 'Juan Dela Cruz',
    username: 'user',
    email: 'juan@brghgmc.com',
    office: 'Hospital Essentials',
    role: UserRole.user,
  ),
];

// Sample exams with questions
final stubExams = [
  Exam(
    id: 'e1',
    title: 'Hospital Safety Protocols',
    office: 'Internal Medicine',
    type: QuizType.multipleChoice,
    scheduledAt: DateTime(2026, 5, 1, 9, 0),
    lectureVideoUrl: 'https://example.com/lecture1',
    questions: [
      const Question(
        id: 'q1',
        text: 'What is the first step in fire safety?',
        type: QuizType.multipleChoice,
        choices: ['Run', 'Alert others', 'Call the fire department', 'Use a fire extinguisher'],
        correctChoiceIndex: 1,
      ),
      const Question(
        id: 'q2',
        text: 'PPE stands for?',
        type: QuizType.multipleChoice,
        choices: ['Personal Protective Equipment', 'Patient Protection Entry', 'Primary Prevention Equipment', 'None'],
        correctChoiceIndex: 0,
      ),
    ],
  ),
  Exam(
    id: 'e2',
    title: 'Medical Equipment Essentials',
    office: 'Hospital Essentials',
    type: QuizType.enumeration,
    scheduledAt: DateTime(2026, 5, 2, 10, 30),
    questions: [
      const Question(
        id: 'q3',
        text: 'List 3 basic life support equipment',
        type: QuizType.enumeration,
        enumerationAnswers: ['AED', 'Oxygen tank', 'Stretcher'],
      ),
    ],
  ),
  Exam(
    id: 'e3',
    title: 'Patient Care Procedures',
    office: 'Hospital Essentials',
    type: QuizType.fillInTheBlank,
    scheduledAt: DateTime(2026, 5, 3, 14, 0),
    questions: [
      const Question(
        id: 'q4',
        text: 'Always wash your _____ before and after patient contact.',
        type: QuizType.fillInTheBlank,
        blankAnswer: 'hands',
      ),
    ],
  ),
];
