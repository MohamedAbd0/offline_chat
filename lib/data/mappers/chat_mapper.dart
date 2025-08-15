import '../../domain/entities/chat.dart';
import '../dtos/chat_dto.dart';

class ChatMapper {
  static Chat toEntity(ChatDto dto) {
    return Chat(
      id: dto.id,
      title: dto.title,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static ChatDto toDto(Chat entity) {
    return ChatDto.fromValues(
      id: entity.id,
      title: entity.title,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<Chat> toEntityList(List<ChatDto> dtos) {
    return dtos.map(toEntity).toList();
  }

  static List<ChatDto> toDtoList(List<Chat> entities) {
    return entities.map(toDto).toList();
  }
}
