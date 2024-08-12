import 'package:studystack/feature/auth/model/users.dart';
import 'package:studystack/core/locale_db/sql_helper.dart';
import 'package:studystack/feature/auth/repository/i_auth_repository.dart';

class AuthRepository extends IAuthRepository{
  @override
    Future<User> login(String email, String password) async {
    final result = await DBHelper.dataBase!.query( // will return ['email': email, 'pass': pass]
      'Users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password], // fill ? with email, fill ? with pass 
    );

    if (result.isNotEmpty) {
      return User.fromJson(result.first); // convert the first record retrieved from the database query (result.first) into a User object.
    } else {
      throw Exception('User not found or incorrect password');
    }
  }


  @override
Future<User> register(String email, String password) async {
  final existingUser = await DBHelper.dataBase!.query(
    'Users',
    where: 'email = ?',
    whereArgs: [email],
  );

  if (existingUser.isNotEmpty) {
    throw Exception('Email is already registered');
  } else {
    // Create a new user object
    final user = User(email: email, password: password);

    // Insert the user into the database
    final userId = await DBHelper.dataBase!.insert('Users', user.toJson());

    // Return the user with the newly generated userId
    return User(
      userId: userId,
      email: email,
      password: password,
    );
  }
}

}