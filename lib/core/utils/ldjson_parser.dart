import 'dart:convert';
import 'dart:typed_data';

class LdJsonParser {
  static Stream<String> parseStream(Stream<Uint8List> byteStream) async* {
    String buffer = '';

    await for (final bytes in byteStream) {
      final chunk = utf8.decode(bytes);
      buffer += chunk;

      // Split by newlines to get complete JSON objects
      final lines = buffer.split('\n');

      // Keep the last potentially incomplete line in buffer
      buffer = lines.last;

      // Process complete lines
      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        try {
          final jsonData = json.decode(line) as Map<String, dynamic>;

          // Handle both 'message.content' and 'response' formats
          String? content;
          if (jsonData.containsKey('message')) {
            final message = jsonData['message'] as Map<String, dynamic>?;
            content = message?['content'] as String?;
          } else if (jsonData.containsKey('response')) {
            content = jsonData['response'] as String?;
          }

          if (content != null && content.isNotEmpty) {
            yield content;
          }

          // Check if done
          final done = jsonData['done'] as bool? ?? false;
          if (done) {
            return;
          }
        } catch (e) {
          // Skip malformed JSON lines
          continue;
        }
      }
    }
  }
}
