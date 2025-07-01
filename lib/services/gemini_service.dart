import 'dart:typed_data';

import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  final gemini = Gemini.instance;

  Future<String> sendText(String text) async {
    final response = await gemini.text(text);
    return response?.output ?? "Hech qanday javob yo'q";
  }

  Future<String> sendTextAndImage(String text, List<int> imageBytes) async {
    final Uint8List uint8Image = Uint8List.fromList(imageBytes);
    final response = await gemini.textAndImage(
      text: text,
      images: [uint8Image],
    );
    return response?.output ?? "Hech qanday javob yo'q";
  }
}
