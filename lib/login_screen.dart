import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showMessage("Login failed: ${e.message}");
    } catch (e) {
      showMessage("Unexpected error: ${e.toString()}");
    }
  }

  Future<void> register() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (!email.contains("@")) {
        showMessage("Invalid email address");
        return;
      }

      if (password.length < 6) {
        showMessage("Password must be at least 6 characters");
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showMessage("Registration successful!");
    } on FirebaseAuthException catch (e) {
      showMessage("Registration failed: ${e.message}");
    } catch (e) {
      showMessage("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login / Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: signIn,
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: register,
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
