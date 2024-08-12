import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studystack/feature/decks/model/deck.dart';
import 'package:studystack/feature/auth/model/users.dart';
import 'package:studystack/screens/reviewDecks.dart';
import 'package:studystack/feature/decks/provider/deck_provider.dart';
import 'package:studystack/feature/state/view_state.dart';

class Mydecks extends ConsumerStatefulWidget {
  final User currentUser;

  const Mydecks({super.key, required this.currentUser});

  @override
  ConsumerState<Mydecks> createState() {
    return _MydecksState();
  }
}

class _MydecksState extends ConsumerState<Mydecks> {
  final titleController = TextEditingController();
  final keyword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final List<Color> deckColors = [
    Colors.purple.shade100,
    Colors.greenAccent.shade100,
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.redAccent.shade100,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deckProvider.notifier).getData(widget.currentUser.userId!);
    });
  }

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
              ////// Done 
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  ref.read(deckProvider.notifier).insert(
                    table: 'Decks',
                    data: {
                      'title': titleController.text,
                      'userId': widget.currentUser.userId!,
                    },
                  ).then((_) {
                    ref.read(deckProvider.notifier).getData(widget.currentUser.userId!);
                   
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
    final deckState = ref.watch(deckProvider);
    final deckNotifier = ref.read(deckProvider.notifier);

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
                      deckNotifier.searchDecks(value, widget.currentUser.userId!).then((_) {
                       ref.read(deckProvider.notifier).getData(widget.currentUser.userId!);});;
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
                child: deckState is LoadingViewState
                    ? const Center(child: CircularProgressIndicator())
                    : deckState is ErrorViewState
                        ? Center(child: Text('Error: ${deckState.errorMessage}'))
                        : deckState is LoadedViewState<List<Decks>>
                            ? ListView.builder(
                                itemCount: deckState.data.length,
                                itemBuilder: (context, index) {
                                  final deck = deckState.data[index];
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
                                                TextEditingController(text: deck.title);

                                            String? newTitle = await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: const Text(
                                                    'Edit Deck Title',
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                  content: TextField(
                                                    controller: controller,
                                                    decoration: const InputDecoration(
                                                      hintText: 'Enter new deck title',
                                                      hintStyle: TextStyle(color: Colors.black),
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                    ),
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(color: Colors.blue),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(controller.text);
                                                      },
                                                      child: const Text(
                                                        'Save',
                                                        style: TextStyle(color: Colors.blue),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (newTitle != null && newTitle.isNotEmpty) {
                                              deckNotifier.update(deck.deckId!, {'title': newTitle}).then((_) {
                                              ref.read(deckProvider.notifier).getData(widget.currentUser.userId!);});;
                                            }
                                          },
                                          child: Text(
                                            deck.title,
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
                                                  onTap: () async {
                                                    if (deckState is! LoadingViewState) {
                                                      // to be done 
                                                      ref.read(deckProvider.notifier).delete(
                                                      "Decks",
                                                       deck.deckId!).then((_) {
                                                      ref.read(deckProvider.notifier).getData(widget.currentUser.userId!);});
                                                    }
                                                  },
                                                  child: deckState is LoadingViewState
                                                      ? const Center(child: CircularProgressIndicator())
                                                      : const Icon(
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
                                                    builder: (context) => ReviewDeck(deck: deck),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(255, 48, 47, 47),
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(6),
                                                child: const Icon(
                                                  Icons.arrow_forward_rounded,
                                                  size: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        contentPadding: const EdgeInsets.all(16),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(child: Text('No decks found')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// delete 