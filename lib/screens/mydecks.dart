import 'package:flutter/material.dart';
import 'package:studystack/core/model/deck.dart';
import 'package:studystack/feature/auth/model/users.dart';
import 'package:studystack/screens/reviewDecks.dart';

import '../core/locale_db/sql_helper.dart';

class Mydecks extends StatefulWidget {
  final User currentUser; // Add currentUser to pass the logged-in user

  const Mydecks({super.key, required this.currentUser});

  @override
  State<Mydecks> createState() => _MydecksState();
}

class _MydecksState extends State<Mydecks> {
  Future<List<Decks>>? decks;

  final List<Color> deckColors = [
    Colors.purple.shade100,
    Colors.greenAccent.shade100,
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.redAccent.shade100,
  ];

  Future<List<Decks>> getAllDecks() {
    return DBHelper.getDecks(
        widget.currentUser.userId!); // Fetch decks for the logged-in user
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        decks = getAllDecks();
      });
    });
    super.initState();
  }

  Future<List<Decks>> serarch() {
    return DBHelper.searchDecks(keyword.text,
        widget.currentUser.userId!); // Search decks for the current user
  }

  final titleController = TextEditingController();
  final keyword = TextEditingController();
  final formKey = GlobalKey<FormState>();


  void showDeckTitleDialog(BuildContext context) {
    titleController.clear();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Enter Deck Title",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Title required";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Deck Title",
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  DBHelper.createDeck(Decks(
                    title: titleController.text,
                    userId: widget
                        .currentUser.userId!, 
                  ))
                      .whenComplete(() {
                    _refresh();
                    Navigator.of(context).pop(true);
                  });
                }
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: AppBar(
              title: const Text(
                "My Decks",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    showDeckTitleDialog(context);
                  },
                ),
              ],
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: keyword,
                    onChanged: (value) {
                      setState(() {
                        decks = serarch();
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.black),
                        onPressed: () {},
                      ),
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Decks>>(
                  future: decks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No decks found',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    } else {
                      final List<Decks> decksList = snapshot.data!;
                      return ListView.builder(
                        itemCount: decksList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 40.0 : 2.0,
                              bottom: 5.0,
                            ),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: deckColors[index % deckColors.length],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: InkWell(
                                  onTap: () async {
                                    final TextEditingController controller =
                                        TextEditingController(
                                            text: decksList[index].title);

                                    String? newTitle = await showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text(
                                            'Edit Deck Title',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          content: TextField(
                                            controller: controller,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter new deck title',
                                              hintStyle: TextStyle(
                                                  color: Colors.black),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(controller.text);
                                              },
                                              child: const Text(
                                                'Save',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (newTitle != null &&
                                        newTitle.isNotEmpty) {
                                      setState(() {
                                        decksList[index].title = newTitle;
                                        DBHelper.updateDeck(
                                            newTitle, decksList[index].deckId!);
                                      });
                                    }
                                  },
                                  child: Text(
                                    decksList[index].title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (decksList[index].deckId != null) {
                                          DBHelper.deleteDeck(
                                                  decksList[index].deckId!)
                                              .whenComplete(() => _refresh())
                                              .catchError((error) {
                                            print("Failed to delete: $error");
                                          });
                                        } else {
                                          print(
                                              "Deck ID is null, cannot delete");
                                        }
                                      },
                                      child: const Icon(
                                        Icons.remove_circle_outline_rounded,
                                        size: 30,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReviewDeck(
                                                  deck: decksList[index]),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 48, 47, 47),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        )),
                                  ],
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      decks = getAllDecks();
  });
  }
}




