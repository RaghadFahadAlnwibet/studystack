import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studystack/feature/decks/view/screen/mydecks.dart';
import 'package:studystack/feature/auth/model/users.dart';
import 'package:studystack/feature/auth/view/screen/login.dart';
import 'package:studystack/feature/auth/provider/auth_provider.dart';
import 'package:studystack/feature/state/view_state.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool isVisible = true;
  bool isVisible2 = true;

  InputDecoration _inputDecoration(String hintText, IconData iconData,
      bool isPasswordField, bool isVisible, VoidCallback onTap) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      prefixIcon: Icon(iconData),
      suffixIcon: isPasswordField
          ? IconButton(
              onPressed: onTap,
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
            )
          : null,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Colors.blue,
          width: 2,
        ),
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
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [
                const AnimatedTitle(),
                const SizedBox(
                  height: 70,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: _inputDecoration(
                      "Email",
                      Icons.email,
                      false,
                      false,
                      () {},
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                    obscureText: isVisible,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: _inputDecoration(
                      "Password",
                      Icons.lock,
                      true,
                      isVisible,
                      () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: confirmpassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != password.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: isVisible2,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: _inputDecoration(
                      "Confirm password",
                      Icons.lock,
                      true,
                      isVisible2,
                      () {
                        setState(() {
                          isVisible2 = !isVisible2;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .9,
                  child: authState is LoadingViewState
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              await authNotifier.signUp(
                                email.text.trim(),
                                password.text.trim(),
                              );

                              final currentState = ref.read(authProvider);
                              if (currentState is LoadedViewState<User>) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Mydecks(currentUser: currentState.data),
                                  ),
                                );
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
                            "Sign up",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                ),
                if (authState is ErrorViewState)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      authState.errorMessage ?? 'An error occurred',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "I have an account",
                      style: TextStyle(color: Color.fromARGB(255, 62, 62, 62)),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedTitle extends StatefulWidget {
  const AnimatedTitle({super.key});

  @override
  State<AnimatedTitle> createState() {
    return _AnimatedTitleState();
  }
}

class _AnimatedTitleState extends State<AnimatedTitle> {
  bool _visible = false;
  bool _slide = false;

  @override
  void initState() {
    super.initState();
    _animateText();
  }

  void _animateText() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _visible = true;
        _slide = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(seconds: 1),
      child: AnimatedSlide(
        offset: _slide ? const Offset(0, 0) : const Offset(0, 1),
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        child: const ListTile(
          title: Text(
            "Create an account",
            style: TextStyle(
                fontSize: 55, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
