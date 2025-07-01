import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:ml_kit_example/screens/chat_screen.dart';

void main() {
  Gemini.init(apiKey: "AIzaSyDUluFpODPzd3II77oCPVbejuRZr6A9pmM");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}
