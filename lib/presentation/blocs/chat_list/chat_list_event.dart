part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

class ChatListLoadRequested extends ChatListEvent {
  const ChatListLoadRequested();
}

class ChatListSearchChanged extends ChatListEvent {
  final String query;

  const ChatListSearchChanged(this.query);

  @override
  List<Object> get props => [query];
}

class ChatListChatCreated extends ChatListEvent {
  final String? title;

  const ChatListChatCreated({this.title});

  @override
  List<Object> get props => [title ?? ''];
}

class ChatListChatRenamed extends ChatListEvent {
  final int chatId;
  final String newTitle;

  const ChatListChatRenamed({required this.chatId, required this.newTitle});

  @override
  List<Object> get props => [chatId, newTitle];
}

class ChatListChatDeleted extends ChatListEvent {
  final int chatId;

  const ChatListChatDeleted(this.chatId);

  @override
  List<Object> get props => [chatId];
}
