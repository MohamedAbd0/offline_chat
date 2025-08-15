import '../../domain/entities/message.dart';
import '../dtos/message_dto.dart';

class MessageMapper {
  static Message toEntity(MessageDto dto) {
    return Message(
      id: dto.id,
      chatId: dto.chatId,
      role: _roleFromDto(dto.role),
      content: dto.content,
      createdAt: dto.createdAt,
      hasError: dto.hasError,
    );
  }

  static MessageDto toDto(Message entity) {
    return MessageDto.fromValues(
      id: entity.id,
      chatId: entity.chatId,
      role: _roleToDto(entity.role),
      content: entity.content,
      createdAt: entity.createdAt,
      hasError: entity.hasError,
    );
  }

  static Role _roleFromDto(RoleDto dto) {
    switch (dto) {
      case RoleDto.system:
        return Role.system;
      case RoleDto.user:
        return Role.user;
      case RoleDto.assistant:
        return Role.assistant;
    }
  }

  static RoleDto _roleToDto(Role role) {
    switch (role) {
      case Role.system:
        return RoleDto.system;
      case Role.user:
        return RoleDto.user;
      case Role.assistant:
        return RoleDto.assistant;
    }
  }

  static List<Message> toEntityList(List<MessageDto> dtos) {
    return dtos.map(toEntity).toList();
  }

  static List<MessageDto> toDtoList(List<Message> entities) {
    return entities.map(toDto).toList();
  }
}
