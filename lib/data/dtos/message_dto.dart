import 'package:hive/hive.dart';

part 'message_dto.g.dart';

@HiveType(typeId: 1)
class MessageDto extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late int chatId;

  @HiveField(2)
  late RoleDto role;

  @HiveField(3)
  late String content;

  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  late bool hasError;

  MessageDto();

  MessageDto.fromValues({
    required this.id,
    required this.chatId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.hasError = false,
  });
}

@HiveType(typeId: 2)
enum RoleDto {
  @HiveField(0)
  system,

  @HiveField(1)
  user,

  @HiveField(2)
  assistant,
}
