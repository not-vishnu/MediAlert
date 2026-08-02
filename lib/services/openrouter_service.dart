import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  // Public constructor
  OpenRouterService();

  // Replace with your own OpenRouter API key
  static const String apiKey = String.fromEnvironment(
    'OPENROUTER_API_KEY',
  );
  // Free model
  static const String model = "poolside/laguna-s-2.1:free";

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "https://github.com/",
          "X-Title": "MediAlert AI",
        },
        body: jsonEncode({
          "model": model,
          "messages": [
            {
              "role": "system",
              "content":
                  "You are MediAlert AI, an AI assistant for medicine reminders. "
                      "Answer only health and medicine related questions. "
                      "Never diagnose diseases. Always advise consulting a qualified doctor "
                      "before starting or stopping any medication.",
            },
            {"role": "user", "content": message},
          ],
          "temperature": 0.7,
          "max_tokens": 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["choices"] != null &&
            data["choices"].isNotEmpty &&
            data["choices"][0]["message"] != null) {
          return data["choices"][0]["message"]["content"];
        }

        return "No response received.";
      } else {
        try {
          final error = jsonDecode(response.body);
          return "Error ${response.statusCode}\n${error["error"]["message"]}";
        } catch (_) {
          return "Error ${response.statusCode}\n${response.body}";
        }
      }
    } catch (e) {
      return "Connection Error\n$e";
    }
  }
}
