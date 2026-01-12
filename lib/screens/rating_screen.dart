import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RatingScreen extends StatefulWidget {
  final int orderId;

  const RatingScreen({super.key, required this.orderId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _reviewController = TextEditingController();
  final _apiService = ApiService();
  int _rating = 0;
  bool _isSubmitting = false;

  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a rating')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _apiService.rateOrder(
        orderId: widget.orderId,
        rating: _rating,
        review: _reviewController.text.isEmpty ? null : _reviewController.text,
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit rating: $e')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Experience')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.stars, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text(
              'How was your experience?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 50,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                labelText: 'Write a review (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Share your thoughts...',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRating,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Rating',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
