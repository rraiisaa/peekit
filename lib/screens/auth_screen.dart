
// CONTOH AUTH

import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _messange = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth"),
      ),
      body: Padding(padding: EdgeInsets.all(20),
      child: Column(children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: "Password"),
        )
      ],
      ),
      ),
    );
  }
}