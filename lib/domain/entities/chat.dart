import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chat({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  Chat copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [id, title, createdAt, updatedAt];
}
