import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final List<Flashcard> _flashcards = [
    Flashcard(
      front: 'What is photosynthesis?',
      back: 'Photosynthesis is the process by which green plants and some other organisms use sunlight to synthesize foods with carbon dioxide and water, generating oxygen as a byproduct.',
      category: 'Biology',
    ),
    Flashcard(
      front: 'What is the capital of France?',
      back: 'Paris is the capital and most populous city of France, with an estimated population of 2,165,423 residents in 2019 in an area of more than 105 square kilometers.',
      category: 'Geography',
    ),
    Flashcard(
      front: 'What is the Pythagorean theorem?',
      back: 'In a right-angled triangle, the square of the length of the hypotenuse equals the sum of the squares of the lengths of the other two sides: a² + b² = c²',
      category: 'Mathematics',
    ),
  ];

  final List<String> _categories = [
    'General',
    'Mathematics',
    'Biology',
    'Geography',
    'History',
    'Physics',
    'Chemistry',
    'Literature',
    'Computer Science',
    'Languages',
    'Other',
  ];

  String _selectedCategory = 'General';

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  void _addNewFlashcard() {
    // Reset selected category to default when opening dialog
    setState(() {
      _selectedCategory = 'General';
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Create New Flashcard'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _questionController,
                      decoration: const InputDecoration(
                        labelText: 'Question',
                        hintText: 'Enter the question for the flashcard',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _answerController,
                      decoration: const InputDecoration(
                        labelText: 'Answer',
                        hintText: 'Enter the answer for the flashcard',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Category:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          items: _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                _selectedCategory = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _questionController.clear();
                    _answerController.clear();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_questionController.text.isNotEmpty && 
                        _answerController.text.isNotEmpty) {
                      setState(() {
                        _flashcards.add(
                          Flashcard(
                            front: _questionController.text,
                            back: _answerController.text,
                            category: _selectedCategory,
                          ),
                        );
                        // Update filtered cards
                        _filterFlashcards();
                      });
                      Navigator.of(context).pop();
                      _questionController.clear();
                      _answerController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Flashcard added to $_selectedCategory category!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in both fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  final TextEditingController _searchController = TextEditingController();
  List<Flashcard> _filteredFlashcards = [];
  bool _isSearching = false;
  String _filterCategory = 'All Categories';

  @override
  void initState() {
    super.initState();
    _filteredFlashcards = List.from(_flashcards);
    _searchController.addListener(_filterFlashcards);
  }

  void _filterFlashcards() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty && _filterCategory == 'All Categories') {
        _filteredFlashcards = List.from(_flashcards);
      } else {
        _filteredFlashcards = _flashcards.where((card) {
          // Filter by search query
          bool matchesQuery = query.isEmpty || 
              card.front.toLowerCase().contains(query) || 
              card.back.toLowerCase().contains(query);

          // Filter by category
          bool matchesCategory = _filterCategory == 'All Categories' || 
              card.category == _filterCategory;

          return matchesQuery && matchesCategory;
        }).toList();
      }
    });
  }

  // Get unique categories from flashcards
  List<String> get _uniqueCategories {
    final Set<String> categories = {'All Categories'};
    for (var card in _flashcards) {
      categories.add(card.category);
    }
    return categories.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search flashcards...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
              )
            : const Text('Flashcards'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to use'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Tap on a card to flip it'),
                      SizedBox(height: 8),
                      Text('• Swipe left/right to navigate between cards'),
                      SizedBox(height: 8),
                      Text('• Use the + button to create new flashcards'),
                      SizedBox(height: 8),
                      Text('• Use the search icon to find specific cards'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category filter
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.category, color: Colors.orange),
                  const SizedBox(width: 8),
                  const Text(
                    'Filter by category:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange.shade200),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.orange.shade50,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _filterCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
                          items: _uniqueCategories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontWeight: category == _filterCategory
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _filterCategory = newValue;
                                _filterFlashcards();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category chips
            if (_flashcards.isNotEmpty)
              Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _uniqueCategories
                      .where((category) => category != 'All Categories')
                      .map((category) {
                    bool isSelected = _filterCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filterCategory = selected ? category : 'All Categories';
                            _filterFlashcards();
                          });
                        },
                        selectedColor: Colors.orange.shade200,
                        checkmarkColor: Colors.deepOrange,
                      ),
                    );
                  }).toList(),
                ),
              ),

            const Divider(),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _filteredFlashcards.isEmpty ? 80 : 0,
              child: _filteredFlashcards.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 32,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _flashcards.isEmpty
                                ? 'No flashcards yet. Create one by tapping the + button!'
                                : 'No matching flashcards found.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: _filteredFlashcards.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      itemCount: _filteredFlashcards.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Dismissible(
                            key: Key(_filteredFlashcards[index].front),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm"),
                                    content: const Text(
                                        "Are you sure you want to delete this flashcard?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) {
                              setState(() {
                                final card = _filteredFlashcards[index];
                                _flashcards.removeWhere(
                                    (element) => element.front == card.front);
                                _filteredFlashcards.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Flashcard deleted'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            child: FlashcardWidget(
                                flashcard: _filteredFlashcards[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewFlashcard,
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Card', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class Flashcard {
  final String front;
  final String back;
  final String category;

  Flashcard({
    required this.front, 
    required this.back, 
    this.category = 'General',
  });
}

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;

  const FlashcardWidget({super.key, required this.flashcard});

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  bool _isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _frontRotation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: math.pi / 2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(math.pi / 2),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _backRotation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(math.pi / 2),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -math.pi / 2, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFrontVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFrontVisible = !_isFrontVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            // Front of the card
            AnimatedBuilder(
              animation: _frontRotation,
              builder: (context, child) {
                final transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_frontRotation.value);
                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: _frontRotation.value < math.pi / 2
                      ? _buildCardSide(
                          widget.flashcard.front,
                          Colors.orange.shade100,
                          Colors.orange,
                          true,
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
            // Back of the card
            AnimatedBuilder(
              animation: _backRotation,
              builder: (context, child) {
                final transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_backRotation.value);
                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: _backRotation.value > -math.pi / 2
                      ? _buildCardSide(
                          widget.flashcard.back,
                          Colors.orange.shade50,
                          Colors.orange.shade800,
                          false,
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSide(String text, Color bgColor, Color borderColor, bool isFront) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isFront ? 'Question' : 'Answer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: borderColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.flashcard.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: borderColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isFront ? 20 : 16,
                    fontWeight: isFront ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
            if (!isFront)
              const Text(
                'Tap to flip back',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
