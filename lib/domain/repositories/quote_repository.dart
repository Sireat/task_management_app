import '../entities/quote.dart';

abstract class QuoteRepository {
  Future<List<Quote>> getQuotes();
}
