import 'package:curve/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // State variables for each question
  double _starRating = 0;
  bool? _isEasyToUnderstand;
  final TextEditingController _improvementController = TextEditingController();
  String _selectedFeature = '4 Cards';
  final TextEditingController _additionalFeedbackController =
      TextEditingController();
  bool _isSubmitting = false;

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            starIndex <= _starRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _starRating = starIndex.toDouble();
            });
          },
        );
      }),
    );
  }

  Future<void> _submitFeedback() async {
    if (_starRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a rating")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? 'anonymous';

      await DatabaseService().addFeedback(
        rating: _starRating,
        isEasyToUnderstand: _isEasyToUnderstand,
        improvementSuggestion: _improvementController.text,
        favoriteFeature: _selectedFeature,
        additionalFeedback: _additionalFeedbackController.text,
        userId: userId,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Thank You!'),
          content: const Text('Your feedback has been submitted.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to settings
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );

      // Clear fields
      setState(() {
        _starRating = 0;
        _isEasyToUnderstand = null;
        _improvementController.clear();
        _selectedFeature = '4 Cards';
        _additionalFeedbackController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting feedback: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: _isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Overall Experience (Star Rating)
                  const Text(
                    '1. How would you describe your overall experience using Curves?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildStarRating(),
                  const SizedBox(height: 24),

                  // 2. First Impression (Yes/No)
                  const Text(
                    '2. First impression of the app — Was it easy to understand?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Yes'),
                          value: true,
                          groupValue: _isEasyToUnderstand,
                          onChanged: (value) {
                            setState(() {
                              _isEasyToUnderstand = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('No'),
                          value: false,
                          groupValue: _isEasyToUnderstand,
                          onChanged: (value) {
                            setState(() {
                              _isEasyToUnderstand = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. How to improve the overall user experience
                  const Text(
                    '3. How could we improve the overall user experience?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _improvementController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Share your suggestions...',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Which feature of the app did you enjoy the most?
                  const Text(
                    '4. Which feature of the app did you enjoy the most?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  RadioListTile<String>(
                    title: const Text('4 Cards'),
                    value: '4 Cards',
                    groupValue: _selectedFeature,
                    onChanged: (value) {
                      setState(() {
                        _selectedFeature = value ?? '';
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Keywords Obsession'),
                    value: 'Keywords Obsession',
                    groupValue: _selectedFeature,
                    onChanged: (value) {
                      setState(() {
                        _selectedFeature = value ?? '';
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Truth or Dare'),
                    value: 'Truth or Dare',
                    groupValue: _selectedFeature,
                    onChanged: (value) {
                      setState(() {
                        _selectedFeature = value ?? '';
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Intimacy Maze'),
                    value: 'Intimacy Maze',
                    groupValue: _selectedFeature,
                    onChanged: (value) {
                      setState(() {
                        _selectedFeature = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // 5. Any other feedback
                  const Text(
                    '5. Do you have any other feedback that could help us make Curves better?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _additionalFeedbackController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Your feedback...',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      child: const Text('Submit Feedback'),
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
    );
  }
}
