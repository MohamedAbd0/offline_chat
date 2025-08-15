import 'package:equatable/equatable.dart';

enum Role { system, user, assistant }

class Message extends Equatable {
  final int id;
  final int chatId;
  final Role role;
  final String content;
  final DateTime createdAt;
  final bool hasError;

  const Message({
    required this.id,
    required this.chatId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.hasError = false,
  });

  Message copyWith({
    int? id,
    int? chatId,
    Role? role,
    String? content,
    DateTime? createdAt,
    bool? hasError,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      hasError: hasError ?? this.hasError,
    );
  }

  @override
  List<Object> get props => [id, chatId, role, content, createdAt, hasError];
}
