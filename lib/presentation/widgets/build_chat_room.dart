// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_chat/di/injector.dart';
import 'package:offline_chat/exports.dart';

class BuildChatRoom extends StatefulWidget {
  final int chatId;
  const BuildChatRoom({super.key, required this.chatId});

  @override
  State<BuildChatRoom> createState() => _BuildChatRoomState();
}

class _BuildChatRoomState extends State<BuildChatRoom> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(
        widget.chatId,
      ), // Add key to ensure new bloc when chatId changes
      create: (_) =>
          getIt<ChatRoomBloc>(param1: widget.chatId)
            ..add(const ChatRoomHistoryLoaded()),
      child: Column(
        children: [
          // Chat header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.psychology, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          // Messages area
          Expanded(
            child: BlocConsumer<ChatRoomBloc, ChatRoomState>(
              listener: (context, state) {
                // Refresh chat list when streaming completes (to update titles)
                if ((!state.isStreaming &&
                        state.currentPartialAssistantContent == null) ||
                    state.titleGenerated) {
                  context.read<ChatListBloc>().add(
                    const ChatListLoadRequested(),
                  );
                }

                // Auto-scroll to bottom when streaming or new messages arrive
                if (state.isStreaming || state.messages.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                }
              },
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(
                          context,
                        ).colorScheme.surfaceContainer.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: _buildMessagesArea(context, state),
                );
              },
            ),
          ),
          // Message composer
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: BlocBuilder<ChatRoomBloc, ChatRoomState>(
              builder: (context, state) {
                return MessageComposer(
                  onSend: (text, attachments) {
                    context.read<ChatRoomBloc>().add(
                      ChatRoomMessageSent(text: text, attachments: attachments),
                    );
                  },
                  isStreaming: state.isStreaming,
                  onStop: () {
                    context.read<ChatRoomBloc>().add(
                      const ChatRoomStreamStopped(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea(BuildContext context, ChatRoomState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.onErrorContainer,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<ChatRoomBloc>().add(
                  const ChatRoomHistoryLoaded(),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.messages.isEmpty && !state.isStreaming) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: state.messages.length + (state.isStreaming ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < state.messages.length) {
          final message = state.messages[index];
          return MessageBubble(message: message);
        } else {
          // Streaming indicator
          return StreamingBubble(
            content: state.currentPartialAssistantContent ?? '',
          );
        }
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Start a conversation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ask me anything you want to know',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SuggestionChip(
                    label: 'Explain quantum physics',
                    onTap: () => context.read<ChatRoomBloc>().add(
                      const ChatRoomMessageSent(
                        text: 'Explain quantum physics in simple terms',
                      ),
                    ),
                  ),
                  SuggestionChip(
                    label: 'Write a poem',
                    onTap: () => context.read<ChatRoomBloc>().add(
                      const ChatRoomMessageSent(
                        text: 'Write a short poem about technology',
                      ),
                    ),
                  ),
                  SuggestionChip(
                    label: 'Help with coding',
                    onTap: () => context.read<ChatRoomBloc>().add(
                      const ChatRoomMessageSent(
                        text: 'Help me write a simple Python function',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
