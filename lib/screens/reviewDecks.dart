import 'package:flutter/material.dart';
import 'package:studystack/feature/decks/model/deck.dart';

class ReviewDeck extends StatefulWidget {
  final Decks deck;
  const ReviewDeck({super.key, required this.deck});

  @override
  State<ReviewDeck> createState() {
    return _ReviewDeck();
  }
}

// Create a deck then create cards
class _ReviewDeck extends State<ReviewDeck> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 70),
            child: Column(
              children: [
                Text(
                  '${widget.deck.title}',
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
  ));
  }
}