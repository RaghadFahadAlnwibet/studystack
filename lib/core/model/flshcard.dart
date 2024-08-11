
class flashcards {
  int? flashcardsId;
  int cardDeckId;
  String back;
  String front;
  DateTime due;

  flashcards({
    this.flashcardsId,
    required this.cardDeckId,
    required this.back,
    required this.front,
    required this.due,  });

  factory flashcards.fromJson(Map<String, dynamic> json) => flashcards(
        cardDeckId: json['cardDeckId'],
        back: json['back'],
        front: json['front'],
        due: json['due'],
      );

  Map<String, dynamic> toJson() {
    return {'cardDeckId': cardDeckId, 'back': back, 'front': front, 'due': due};
  }
}
