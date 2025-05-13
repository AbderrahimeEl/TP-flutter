import 'package:flutter/material.dart';

class KeyPointsScreen extends StatefulWidget {
  const KeyPointsScreen({super.key});

  @override
  State<KeyPointsScreen> createState() => _KeyPointsScreenState();
}

class _KeyPointsScreenState extends State<KeyPointsScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _keyPoints = [];
  bool _showKeyPoints = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _extractKeyPoints() {
    // Mock key points extraction
    setState(() {
      _showKeyPoints = true;
      _keyPoints.clear();
      _keyPoints.add('The main argument presented in the text revolves around the importance of critical thinking in education.');
      _keyPoints.add('Research suggests that students who engage in regular problem-solving activities develop stronger analytical skills.');
      _keyPoints.add('The conclusion emphasizes the need for curriculum reform to incorporate more practical, real-world applications of theoretical concepts.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extract Key Points'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter text to extract key points:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Paste your text here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _extractKeyPoints,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Extract Key Points'),
            ),
            const SizedBox(height: 24),
            if (_showKeyPoints) ...[
              const Text(
                'Key Points:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _keyPoints.map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}