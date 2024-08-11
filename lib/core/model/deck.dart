class Decks {
  final int? deckId;
  String title;
  final int userId;

  Decks({
    this.deckId,
    required this.title,
    required this.userId,
  });

  factory Decks.fromJson(Map<String, dynamic> json) => Decks(
        title: json['title'],
        deckId: json['deckId'],
        userId: json['userId']

      );

  Map<String, dynamic> toJson() {
    return {'title': title, 'userId': userId};
  }
}