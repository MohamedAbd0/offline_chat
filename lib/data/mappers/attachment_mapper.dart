import '../../domain/entities/attachment.dart';
import '../dtos/attachment_dto.dart';

class AttachmentMapper {
  static Attachment toEntity(AttachmentDto dto) {
    return Attachment(
      id: dto.id,
      messageId: dto.messageId,
      type: _typeFromDto(dto.type),
      path: dto.path,
      displayName: dto.displayName,
      bytesLength: dto.bytesLength,
    );
  }

  static AttachmentDto toDto(Attachment entity) {
    return AttachmentDto.fromValues(
      id: entity.id,
      messageId: entity.messageId,
      type: _typeToDto(entity.type),
      path: entity.path,
      displayName: entity.displayName,
      bytesLength: entity.bytesLength,
    );
  }

  static AttachmentType _typeFromDto(AttachmentTypeDto dto) {
    switch (dto) {
      case AttachmentTypeDto.image:
        return AttachmentType.image;
      case AttachmentTypeDto.text:
        return AttachmentType.text;
      case AttachmentTypeDto.pdf:
        return AttachmentType.pdf;
    }
  }

  static AttachmentTypeDto _typeToDto(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return AttachmentTypeDto.image;
      case AttachmentType.text:
        return AttachmentTypeDto.text;
      case AttachmentType.pdf:
        return AttachmentTypeDto.pdf;
    }
  }

  static List<Attachment> toEntityList(List<AttachmentDto> dtos) {
    return dtos.map(toEntity).toList();
  }

  static List<AttachmentDto> toDtoList(List<Attachment> entities) {
    return entities.map(toDto).toList();
  }
}
