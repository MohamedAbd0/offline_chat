part of 'chat_room_bloc.dart';

class ChatRoomState extends Equatable {
  final int chatId;
  final List<Message> messages;
  final bool isLoading;
  final bool isStreaming;
  final String? currentPartialAssistantContent;
  final String? error;
  final bool titleGenerated;

  const ChatRoomState({
    required this.chatId,
    this.messages = const [],
    this.isLoading = false,
    this.isStreaming = false,
    this.currentPartialAssistantContent,
    this.error,
    this.titleGenerated = false,
  });

  ChatRoomState copyWith({
    int? chatId,
    List<Message>? messages,
    bool? isLoading,
    bool? isStreaming,
    String? currentPartialAssistantContent,
    String? error,
    bool? titleGenerated,
  }) {
    return ChatRoomState(
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isStreaming: isStreaming ?? this.isStreaming,
      currentPartialAssistantContent: currentPartialAssistantContent,
      error: error,
      titleGenerated: titleGenerated ?? this.titleGenerated,
    );
  }

  @override
  List<Object?> get props => [
    chatId,
    messages,
    isLoading,
    isStreaming,
    currentPartialAssistantContent,
    error,
    titleGenerated,
  ];
}
