import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Fitness App'), centerTitle: true),
      body: const Center(
        child: Text(
          'Welkom bij je AI Fitness App 💪',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
