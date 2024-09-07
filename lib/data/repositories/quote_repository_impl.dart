import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/quote.dart';
import '../../domain/repositories/quote_repository.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  @override
  Future<List<Quote>> getQuotes() async {
    try {
      final response = await rootBundle.loadString('assets/quotes.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Quote.fromJson(json)).toList();
    } catch (e) {
      print('Failed to load quotes: $e');
      return [];
    }
  }
}
