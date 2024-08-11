import 'package:flutter/material.dart';
// import 'package:studystack/widgets/navbar.dart';
import 'package:studystack/core/model/users.dart';
//import 'package:studystack/screens/authentication/login.dart';
import 'package:studystack/screens/mydecks.dart';
import 'package:studystack/screens/authentication/login.dart';
//import 'package:studystack/SQLite/sqlite.dart';




void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Users currentUser = Users(
    // userId: 1,
    //  email: "r@123",
    //  password: "123"
    // );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
       home: const  LoginScreen(),
    );
}
}

    

