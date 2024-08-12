class Decks {
  final int? deckId;
  String title;
  final int? userId;

  Decks({
    this.deckId,
    required this.title,
    this.userId,
  });

  factory Decks.fromJson(Map<String, dynamic> json) => Decks(
        title: json['title'],
        deckId: json['id'],
      );

  Map<String, dynamic> toJson() {
    return {'id': deckId,'title': title};
  }
}


// primery key 