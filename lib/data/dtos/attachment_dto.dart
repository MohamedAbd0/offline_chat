import 'package:hive/hive.dart';

part 'attachment_dto.g.dart';

@HiveType(typeId: 3)
class AttachmentDto extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late int messageId;

  @HiveField(2)
  late AttachmentTypeDto type;

  @HiveField(3)
  late String path;

  @HiveField(4)
  late String displayName;

  @HiveField(5)
  late int bytesLength;

  AttachmentDto();

  AttachmentDto.fromValues({
    required this.id,
    required this.messageId,
    required this.type,
    required this.path,
    required this.displayName,
    required this.bytesLength,
  });
}

@HiveType(typeId: 4)
enum AttachmentTypeDto {
  @HiveField(0)
  image,

  @HiveField(1)
  text,

  @HiveField(2)
  pdf,
}
