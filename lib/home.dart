import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: Center(
        child: Text("Welcome to dashboard ${args['firstname']} ${args['lastname']}"),
      ),
    );
  }
}
