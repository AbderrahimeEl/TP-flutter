import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'What is the largest organ in the human body?',
      options: ['Brain', 'Liver', 'Skin', 'Heart'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Which of these is NOT a programming language?',
      options: ['Java', 'Python', 'Cobra', 'Hadoop'],
      correctAnswerIndex: 3,
    ),
  ];

  final List<int?> _selectedAnswers = List.filled(3, null);
  bool _showResults = false;

  void _selectAnswer(int questionIndex, int answerIndex) {
    setState(() {
      _selectedAnswers[questionIndex] = answerIndex;
    });
  }

  void _checkAnswers() {
    // Check if all questions have been answered
    if (_selectedAnswers.every((answer) => answer != null)) {
      setState(() {
        _showResults = true;
      });
    } else {
      // Show a snackbar if not all questions are answered
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before checking results.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetQuiz() {
    setState(() {
      _selectedAnswers.fillRange(0, _selectedAnswers.length, null);
      _showResults = false;
    });
  }

  int _getCorrectAnswersCount() {
    int count = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctAnswerIndex) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showResults) ...[
              _buildResultsCard(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _resetQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Try Again'),
              ),
            ] else ...[
              const Text(
                'Select the correct answer for each question:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return _buildQuestionCard(index);
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkAnswers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Check Answers'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int questionIndex) {
    final question = _questions[questionIndex];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${questionIndex + 1}:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              question.options.length,
              (optionIndex) => _buildOptionTile(
                questionIndex,
                optionIndex,
                question.options[optionIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(int questionIndex, int optionIndex, String optionText) {
    final isSelected = _selectedAnswers[questionIndex] == optionIndex;
    
    return RadioListTile<int>(
      title: Text(optionText),
      value: optionIndex,
      groupValue: _selectedAnswers[questionIndex],
      onChanged: (value) => _selectAnswer(questionIndex, value!),
      activeColor: Colors.green,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      dense: true,
    );
  }

  Widget _buildResultsCard() {
    final correctCount = _getCorrectAnswersCount();
    final totalCount = _questions.length;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Quiz Results',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You got $correctCount out of $totalCount correct!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              _questions.length,
              (index) => _buildResultItem(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(int questionIndex) {
    final question = _questions[questionIndex];
    final selectedAnswer = _selectedAnswers[questionIndex];
    final isCorrect = selectedAnswer == question.correctAnswerIndex;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your answer: ${question.options[selectedAnswer!]}',
            style: TextStyle(
              color: isCorrect ? Colors.green : Colors.red,
            ),
          ),
          if (!isCorrect)
            Text(
              'Correct answer: ${question.options[question.correctAnswerIndex]}',
              style: const TextStyle(
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}