part of 'chat_room_bloc.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();

  @override
  List<Object> get props => [];
}

class ChatRoomHistoryLoaded extends ChatRoomEvent {
  const ChatRoomHistoryLoaded();
}

class ChatRoomMessageSent extends ChatRoomEvent {
  final String text;
  final List<String> attachments;

  const ChatRoomMessageSent({required this.text, this.attachments = const []});

  @override
  List<Object> get props => [text, attachments];
}

class ChatRoomStreamChunkArrived extends ChatRoomEvent {
  final String content;

  const ChatRoomStreamChunkArrived(this.content);

  @override
  List<Object> get props => [content];
}

class ChatRoomStreamCompleted extends ChatRoomEvent {
  const ChatRoomStreamCompleted();
}

class ChatRoomStreamStopped extends ChatRoomEvent {
  const ChatRoomStreamStopped();
}
