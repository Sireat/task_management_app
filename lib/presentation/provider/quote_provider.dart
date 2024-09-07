import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/repositories/quote_repository.dart';
import '../../domain/entities/quote.dart';

class QuoteProvider extends ChangeNotifier {
  final QuoteRepository quoteRepository;
  List<Quote> _quotes = [];
  Quote? _currentQuote;
  Timer? _quoteTimer;

  QuoteProvider({required this.quoteRepository}) {
    fetchQuotes(); // Fetch quotes when the provider is initialized
  }

  Quote? get currentQuote => _currentQuote;

  // Change _fetchQuotes to public
  Future<void> fetchQuotes() async {
    try {
      _quotes = await quoteRepository.getQuotes(); // Fetch quotes from the repository
      if (_quotes.isNotEmpty) {
        _updateQuote();
        _startQuoteTimer();
      }
    } catch (e) {
      print('Failed to fetch quotes: $e');
    }
  }

  void _updateQuote() {
    final randomIndex = (DateTime.now().millisecondsSinceEpoch % _quotes.length).toInt();
    _currentQuote = _quotes[randomIndex];
    notifyListeners();
  }

  void _startQuoteTimer() {
    _quoteTimer?.cancel(); // Cancel any existing timer
    _quoteTimer = Timer.periodic(Duration(seconds: 10), (_) {
      _updateQuote();
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    super.dispose();
  }
}
