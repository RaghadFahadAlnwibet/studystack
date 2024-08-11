import 'package:studystack/feature/auth/model/users.dart';
import 'package:studystack/feature/auth/repository/i_auth_repository.dart';

class AuthRepository extends IAuthRepository{
  @override
  Future<User> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<User> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

}