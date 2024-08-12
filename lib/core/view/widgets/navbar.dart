import 'package:flutter/material.dart';
import 'package:studystack/feature/decks/view/screen/mydecks.dart';
import 'package:studystack/screens/Favorite.dart';
import 'package:studystack/screens/setting.dart';
import 'package:studystack/feature/auth/model/users.dart';

class CustomNavigationBar extends StatefulWidget {
  final User currentUser; // Pass the current user to this widget

  const CustomNavigationBar({super.key, required this.currentUser});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int currentIndex = 0;

  late List<Widget> screens; // Declare the screens list

  @override
  void initState() {
    super.initState();
    screens = [
      Mydecks(currentUser: widget.currentUser),
      const Favorite(),
      const Setting(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 15, right: 25, left: 25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 44, 40, 40),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 44, 40, 40),
            selectedItemColor: const Color.fromARGB(255, 221, 218, 218),
            unselectedItemColor: Colors.grey,
            iconSize: 30,
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.layers_outlined),
                label: 'Deck',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_sharp),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
     ),
  );
  }
}