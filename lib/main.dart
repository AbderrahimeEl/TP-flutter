import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/summarization_screen.dart';
import 'screens/key_points_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DorossAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/flashcards': (context) => const FlashcardScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/summarize': (context) => const SummarizationScreen(),
        '/keypoints': (context) => const KeyPointsScreen(),
      },
    );
  }
}
