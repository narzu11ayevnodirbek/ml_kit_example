import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_service.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final gemini = GeminiService();
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty && _image == null) return;

    setState(() {
      _messages.add({"text": text, "isUser": true});
      _isLoading = true;
      _controller.clear();
    });

    String response = "...";

    if (_image != null) {
      final bytes = await _image!.readAsBytes();
      response = await gemini.sendTextAndImage(text, bytes);
      _image = null;
    } else {
      response = await gemini.sendText(text);
    }

    setState(() {
      _messages.add({"text": response, "isUser": false});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, index) => ChatBubble(
                message: _messages[index]["text"],
                isUser: _messages[index]["isUser"],
              ),
            ),
          ),
          if (_image != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(_image!, height: 100),
            ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SpinKitThreeBounce(color: Colors.blue, size: 30.0),
            ),
          SafeArea(
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.add), onPressed: _pickImage),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Matn yozing...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
