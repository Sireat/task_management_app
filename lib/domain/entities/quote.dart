class Quote {
  final String quote;
  final String author;

  Quote({required this.quote, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['quote'],
      author: json['author'] ?? 'Unknown',
    );
  }
}
