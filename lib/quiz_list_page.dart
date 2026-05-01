import 'package:flutter/material.dart';

//  Placeholder data models 

enum QuizType { multipleChoice, enumeration, fillInTheBlank }

extension QuizTypeLabel on QuizType {
  String get label {
    switch (this) {
      case QuizType.multipleChoice:
        return 'Multiple Choice';
      case QuizType.enumeration:
        return 'Enumeration';
      case QuizType.fillInTheBlank:
        return 'Fill in the Blank';
    }
  }
}

class QuizItem {
  final String title;
  final String office;       // category / office
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

// Quiz data 

final _stubQuizzes = [
  QuizItem(
    title: 'Cyber ni mo',
    office: 'IT',
    type: QuizType.multipleChoice,
    dateTime: DateTime(2026, 5, 1, 9, 0),
    questionCount: 20,
  ),
  QuizItem(
    title: 'Medical Equipment Essentials',
    office: 'Internal medicine',
    type: QuizType.enumeration,
    dateTime: DateTime(2026, 5, 2, 10, 30),
    questionCount: 15,
  ),
  QuizItem(
    title: 'Patient Care Procedures',
    office: 'Patient Care',
    type: QuizType.fillInTheBlank,
    dateTime: DateTime(2026, 5, 3, 14, 0),
    questionCount: 10,
  ),
  QuizItem(
    title: 'ICU — Unit 1',
    office: 'ICU',
    type: QuizType.multipleChoice,
    dateTime: DateTime(2026, 5, 5, 8, 0),
    questionCount: 50,
  ),
  QuizItem(
    title: 'ORGanzational chart 2',
    office: 'PEtru Interns',
    type: QuizType.enumeration,
    dateTime: DateTime(2026, 5, 6, 8, 0),
    questionCount: 30,
  ),
];

//  Page 

class QuizListPage extends StatefulWidget {
  const QuizListPage({super.key});

  @override
  State<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  // selected office filter — null ibig sabihnin  "All"
  String? _selectedOffice;
  // selected quiz type filter — null ibig sabihin "All"
  QuizType? _selectedType;

  List<String> get _offices {
    final offices = _stubQuizzes.map((q) => q.office).toSet().toList();
    offices.sort();
    return offices;
  }

  List<QuizItem> get _filtered {
    return _stubQuizzes.where((q) {
      final officeMatch =
          _selectedOffice == null || q.office == _selectedOffice;
      final typeMatch =
          _selectedType == null || q.type == _selectedType;
      return officeMatch && typeMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Quizzes'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Filter bar 
          _FilterBar(
            offices: _offices,
            selectedOffice: _selectedOffice,
            selectedType: _selectedType,
            onOfficeChanged: (v) => setState(() => _selectedOffice = v),
            onTypeChanged: (v) => setState(() => _selectedType = v),
          ),

          const Divider(height: 1),

          //  Quiz list 
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('No quizzes found.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) =>
                        _QuizCard(quiz: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// Filter bar 

class _FilterBar extends StatelessWidget {
  final List<String> offices;
  final String? selectedOffice;
  final QuizType? selectedType;
  final ValueChanged<String?> onOfficeChanged;
  final ValueChanged<QuizType?> onTypeChanged;

  const _FilterBar({
    required this.offices,
    required this.selectedOffice,
    required this.selectedType,
    required this.onOfficeChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          // Office / category dropdown
          DropdownButton<String?>(
            hint: const Text('All Offices'),
            value: selectedOffice,
            items: [
              const DropdownMenuItem(value: null, child: Text('All Offices')),
              ...offices.map((o) =>
                  DropdownMenuItem(value: o, child: Text(o))),
            ],
            onChanged: onOfficeChanged,
          ),

          // Quiz type dropdown
          DropdownButton<QuizType?>(
            hint: const Text('All Types'),
            value: selectedType,
            items: [
              const DropdownMenuItem(value: null, child: Text('All Types')),
              ...QuizType.values.map((t) =>
                  DropdownMenuItem(value: t, child: Text(t.label))),
            ],
            onChanged: onTypeChanged,
          ),
        ],
      ),
    );
  }
}

//  Quiz card

class _QuizCard extends StatelessWidget {
  final QuizItem quiz;
  const _QuizCard({required this.quiz});

  @override
  Widget build(BuildContext context) {
    final date =
        '${quiz.dateTime.year}-${_pad(quiz.dateTime.month)}-${_pad(quiz.dateTime.day)}';
    final time =
        '${_pad(quiz.dateTime.hour)}:${_pad(quiz.dateTime.minute)}';

    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        // quiz title
        title: Text(quiz.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // office / category
            Text('Office: ${quiz.office}'),
            // exam type
            Text('Type: ${quiz.type.label}'),
            // date and time
            Text('Date: $date  •  Time: $time'),
            // question count
            Text('Questions: ${quiz.questionCount}'),
          ],
        ),
        // take quiz button 
        trailing: ElevatedButton(
          onPressed: () {
            
          },
          child: const Text('Take'),
        ),
      ),
    );
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}
