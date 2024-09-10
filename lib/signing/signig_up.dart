import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signing_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 161, 13, 57), Colors.lightBlueAccent],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: [
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                TextField(
                  controller: _userNameTextController,
                  obscureText: false,
                  enableSuggestions: true,
                  autocorrect: true,
                  cursorColor: const Color.fromARGB(255, 27, 25, 2),
                  style: TextStyle(color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      color: Color.fromARGB(255, 7, 6, 1),
                    ),
                    labelText: "Enter your Username",
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.yellow.withOpacity(0.3),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none)),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailTextController,
                  obscureText: false,
                  enableSuggestions: true,
                  autocorrect: true,
                  cursorColor: Colors.yellow,
                  style: TextStyle(color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 8, 8, 0),
                    ),
                    labelText: "Enter your Email",
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.yellow.withOpacity(0.3),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordTextController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  cursorColor: const Color.fromARGB(255, 255, 255, 255),
                  style: TextStyle(color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color.fromARGB(255, 8, 8, 1),
                    ),
                    labelText: "Enter your Password",
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.yellow.withOpacity(0.3),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none)),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color.fromARGB(255, 2, 8, 14);
                        }
                        return const Color.fromARGB(255, 15, 112, 28);
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)))),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SignUp",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 9, 17),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have account?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SigninScreen()),
                        );
                      },
                      child: const Text(
                        " Sign In",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
