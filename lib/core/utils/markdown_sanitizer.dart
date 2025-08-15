class MarkdownSanitizer {
  static String sanitize(String markdown) {
    // Basic sanitization - remove potentially harmful content
    // In production, you might want a more sophisticated sanitizer
    return markdown
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', dotAll: true), '')
        .replaceAll(RegExp(r'<iframe[^>]*>.*?</iframe>', dotAll: true), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '');
  }

  static String extractPlainText(String markdown) {
    // Remove markdown formatting to get plain text
    return markdown
        .replaceAll(RegExp(r'#{1,6}\s+'), '') // Headers
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1') // Bold
        .replaceAll(RegExp(r'\*(.*?)\*'), r'$1') // Italic
        .replaceAll(RegExp(r'`(.*?)`'), r'$1') // Inline code
        .replaceAll(RegExp(r'\[(.*?)\]\(.*?\)'), r'$1') // Links
        .replaceAll(RegExp(r'^[\s]*[-*+]\s+', multiLine: true), '') // Lists
        .replaceAll(
          RegExp(r'^[\s]*\d+\.\s+', multiLine: true),
          '',
        ) // Numbered lists
        .trim();
  }
}
