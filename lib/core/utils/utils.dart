// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Utils {
  // ChatGPT-like markdown style sheet
  static MarkdownStyleSheet buildMarkdownStyleSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MarkdownStyleSheet(
      p: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      strong: TextStyle(
        fontSize: 15,
        height: 1.6,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      em: TextStyle(
        fontSize: 15,
        height: 1.6,
        fontStyle: FontStyle.italic,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      // Inline code styling - for `code` - ChatGPT-like appearance
      code: TextStyle(
        fontSize: 14,
        fontFamily: 'SF Mono, Monaco, Inconsolata, Roboto Mono, monospace',
        backgroundColor: isDark
            ? const Color(0xFF2D3748) // Darker, more sophisticated gray
            : const Color(0xFFEDF2F7), // Light gray similar to ChatGPT
        color: isDark
            ? const Color(0xFF68D391) // Mint green for dark mode
            : const Color(0xFF2B6CB0), // Professional blue for light mode
        letterSpacing: 0.3,
        fontWeight: FontWeight.w500,
      ),
      // Code block styling - for ```code```
      codeblockPadding: const EdgeInsets.all(0),
      codeblockDecoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(0),
      ),
      blockquote: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.only(left: 16),
      h1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.3,
      ),
      h2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.3,
      ),
      h3: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.3,
      ),
      h4: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.3,
      ),
      h5: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.3,
      ),
      h6: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.3,
      ),
      listBullet: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      tableHead: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      tableBody: TextStyle(
        fontSize: 15,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      tableBorder: TableBorder.all(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        width: 1,
      ),
      tableCellsPadding: const EdgeInsets.all(12),
    );
  }
}
