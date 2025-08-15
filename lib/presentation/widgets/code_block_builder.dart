// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:offline_chat/exports.dart';

class CodeBlockBuilder extends MarkdownElementBuilder {
  final BuildContext context;

  CodeBlockBuilder(this.context);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String language =
        element.attributes['class']?.replaceFirst('language-', '') ?? '';
    final String code = element.textContent;

    if (code.isEmpty) return null;

    // Only apply fancy styling to actual multi-line code blocks
    // This should be very restrictive - only for actual code blocks, not inline code
    final bool isCodeBlock =
        // Must be a pre tag (actual code block) OR
        element.tag == 'pre' ||
        // Must have language AND multiple lines OR
        (language.isNotEmpty &&
            code.contains('\n') &&
            code.trim().split('\n').length > 1) ||
        // Must be very long content that looks like code
        (code.length > 100 && code.contains('\n'));

    if (!isCodeBlock) {
      // Return null to use default inline code styling
      return null;
    }

    // Determine if we're in dark mode
    final isDark =
        preferredStyle?.color != null &&
        ThemeData.estimateBrightnessForColor(preferredStyle!.color!) ==
            Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with language and copy button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF374151), const Color(0xFF1F2937)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF4A5568).withOpacity(0.3)
                      : const Color(0xFFCBD5E0).withOpacity(0.5),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  _getLanguageIcon(language),
                  size: 16,
                  color: const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 8),
                Text(
                  language.isEmpty ? 'code' : language,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFD1D5DB),
                    fontFamily:
                        'SF Mono, Monaco, Inconsolata, Roboto Mono, monospace',
                  ),
                ),
                const Spacer(),
                CopyButton(code: code, isDark: isDark),
              ],
            ),
          ),
          // Code content with syntax highlighting
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1A202C)
                  : const Color(
                      0xFF2D3748,
                    ), // Always dark for syntax highlighting
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
            ),
            child: HighlightView(
              code,
              language: language.isNotEmpty ? language : 'plaintext',
              theme:
                  vs2015Theme, // Always use dark theme for better syntax highlighting
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontSize: 14,
                fontFamily:
                    'SF Mono, Monaco, Inconsolata, Roboto Mono, monospace',
                height: 1.5,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLanguageIcon(String language) {
    switch (language.toLowerCase()) {
      case 'dart':
        return Icons.flutter_dash;
      case 'javascript':
      case 'js':
        return Icons.javascript;
      case 'python':
        return Icons.code;
      case 'java':
        return Icons.coffee;
      case 'html':
        return Icons.web;
      case 'css':
        return Icons.style;
      case 'json':
        return Icons.data_object;
      case 'xml':
        return Icons.code;
      case 'sql':
        return Icons.storage;
      case 'bash':
      case 'shell':
        return Icons.terminal;
      default:
        return Icons.code;
    }
  }
}
