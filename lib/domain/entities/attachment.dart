import 'package:equatable/equatable.dart';

enum AttachmentType { image, text, pdf }

class Attachment extends Equatable {
  final int id;
  final int messageId;
  final AttachmentType type;
  final String path;
  final String displayName;
  final int bytesLength;

  const Attachment({
    required this.id,
    required this.messageId,
    required this.type,
    required this.path,
    required this.displayName,
    required this.bytesLength,
  });

  Attachment copyWith({
    int? id,
    int? messageId,
    AttachmentType? type,
    String? path,
    String? displayName,
    int? bytesLength,
  }) {
    return Attachment(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      type: type ?? this.type,
      path: path ?? this.path,
      displayName: displayName ?? this.displayName,
      bytesLength: bytesLength ?? this.bytesLength,
    );
  }

  @override
  List<Object> get props => [
    id,
    messageId,
    type,
    path,
    displayName,
    bytesLength,
  ];
}
