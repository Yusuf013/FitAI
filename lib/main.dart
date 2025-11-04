import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // als je al een eigen pagina hebt gemaakt

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Fitness App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(), // 👈 jouw eigen pagina
    );
  }
}
