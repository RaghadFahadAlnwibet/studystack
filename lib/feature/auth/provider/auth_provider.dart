import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studystack/feature/auth/repository/i_auth_repository.dart';
import 'package:studystack/feature/state/view_state.dart';
import 'package:studystack/feature/auth/model/users.dart';
import 'package:studystack/feature/auth/repository/auth_repository.dart'; 


final authProvider = StateNotifierProvider<AuthStateNotifier, ViewState>((ref) {
  final authRepository = AuthRepository(); 
  return AuthStateNotifier(authRepository);
});

class AuthStateNotifier extends StateNotifier<ViewState> {
  final IAuthRepository authRepository;

  AuthStateNotifier(this.authRepository) : super(InitialViewState());

  Future<void> login(String email, String password) async {
    state = LoadingViewState();

    try {
      final user = await authRepository.login(email, password);
      state = LoadedViewState<User>(user);
    } catch (e) {
      state = ErrorViewState(errorMessage: e.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    state = LoadingViewState();

    try {
      final user = await authRepository.register(email, password);
      state = LoadedViewState<User>(user);
    } catch (e) {
      state = ErrorViewState(errorMessage: e.toString());
    }
  }

  void logout() { //  logging out the user
    state = EmptyViewState();
  }
}
