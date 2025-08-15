part of 'chat_list_bloc.dart';

class ChatListState extends Equatable {
  final List<Chat> chats;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const ChatListState({
    this.chats = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  ChatListState copyWith({
    List<Chat>? chats,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [chats, searchQuery, isLoading, error];
}
