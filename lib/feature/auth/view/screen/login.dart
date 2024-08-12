import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studystack/feature/auth/view/screen/signup.dart';
import 'package:studystack/feature/decks/view/screen/mydecks.dart';
import 'package:studystack/feature/auth/model/users.dart';
import 'package:studystack/feature/auth/provider/auth_provider.dart';
import 'package:studystack/feature/state/view_state.dart';
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isVisible = true;
  bool isLoginTrue = false;

  final _formKey = GlobalKey<FormState>();

  InputDecoration _inputDecoration(
      String hintText, IconData iconData, bool isPasswordField) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(iconData),
      suffixIcon: isPasswordField
          ? IconButton(
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
            )
          : null,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider); 
    final authNotifier = ref.read(authProvider.notifier); 

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset("assests/logo.png"),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration("Email", Icons.email, false),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      obscureText: isVisible,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration("Password", Icons.lock, true),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50, 
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: authState is LoadingViewState
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await authNotifier.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );

                                final currentState = ref.read(authProvider);
                                if (currentState is LoadedViewState<User>) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Mydecks(currentUser: currentState.data),
                                    ),
                                  );
                                } else if (currentState is ErrorViewState) {
                                  setState(() {
                                    isLoginTrue = true;
                                  });
                                }
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Color.fromARGB(255, 62, 62, 62)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  isLoginTrue 
                    ? const Text(
                        "Username or password is incorrect",
                        style: TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
