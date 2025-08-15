// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:offline_chat/exports.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == Role.user;
    final isAssistant = message.role == Role.assistant;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isAssistant
            ? Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.6)
            : Colors.transparent,
        border: Border(
          top: isAssistant
              ? BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 0.5,
                )
              : BorderSide.none,
          bottom: isAssistant
              ? BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 0.5,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 12, top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isUser
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
            ),
            child: Icon(
              isUser ? Icons.person : Icons.psychology,
              color: Colors.white,
              size: 16,
            ),
          ),
          // Message content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role label
                  Text(
                    isUser ? 'You' : 'AI',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Message text
                  MarkdownBody(
                    data: message.content,
                    styleSheet: Utils.buildMarkdownStyleSheet(context),
                    selectable: true,
                    builders: {'code': CodeBlockBuilder(context)},
                  ),
                  if (message.hasError) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Error occurred',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Actions
          if (isAssistant && !message.hasError) ...[
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    // Copy to clipboard
                  },
                  icon: Icon(
                    Icons.copy,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
