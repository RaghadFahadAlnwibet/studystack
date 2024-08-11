import 'package:flutter/material.dart';
import 'package:studystack/feature/auth/view/screen/login.dart';
import 'core/locale_db/sql_helper.dart';





void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

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

    

