import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mym_raktaveer_frontend/forgot_password.dart';
import 'package:mym_raktaveer_frontend/main.dart';
import 'package:mym_raktaveer_frontend/utils.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    super.key,
    required this.onclickedSignUp,
  });

  final VoidCallback? onclickedSignUp;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Email Input
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),

          // Password Input
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24.0),

          // Sign-In Button
          ElevatedButton(
            onPressed: signIn,
            child: const Text('Sign In'),
          ),

          const SizedBox(
            height: 24,
          ),

          GestureDetector(
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 235, 34, 34),
              ),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage())),
          ),

          const SizedBox(
            height: 24,
          ),

          RichText(
            text: TextSpan(
              style: const TextStyle(color: Color.fromARGB(255, 56, 55, 55)),
              text: 'No account? ',
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Check if the callback is not null before invoking it
                      if (widget.onclickedSignUp != null) {
                        // Pass the current context to the callback
                        widget.onclickedSignUp!();
                      }
                    },
                  text: "Sign Up",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 235, 34, 34),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      Utils.showSnackBar(e.message);
    } finally {
      // ignore: use_build_context_synchronously
      navigatorKey.currentState!
          .popUntil((route) => route.isFirst); // Close the loading indicator
    }
  }
}
