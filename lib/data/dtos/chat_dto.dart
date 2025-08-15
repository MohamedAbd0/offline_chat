import 'package:hive/hive.dart';

part 'chat_dto.g.dart';

@HiveType(typeId: 0)
class ChatDto extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late DateTime createdAt;

  @HiveField(3)
  late DateTime updatedAt;

  ChatDto();

  ChatDto.fromValues({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
}
