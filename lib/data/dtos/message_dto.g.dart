// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageDtoAdapter extends TypeAdapter<MessageDto> {
  @override
  final int typeId = 1;

  @override
  MessageDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageDto()
      ..id = fields[0] as int
      ..chatId = fields[1] as int
      ..role = fields[2] as RoleDto
      ..content = fields[3] as String
      ..createdAt = fields[4] as DateTime
      ..hasError = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, MessageDto obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chatId)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.hasError);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoleDtoAdapter extends TypeAdapter<RoleDto> {
  @override
  final int typeId = 2;

  @override
  RoleDto read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RoleDto.system;
      case 1:
        return RoleDto.user;
      case 2:
        return RoleDto.assistant;
      default:
        return RoleDto.system;
    }
  }

  @override
  void write(BinaryWriter writer, RoleDto obj) {
    switch (obj) {
      case RoleDto.system:
        writer.writeByte(0);
        break;
      case RoleDto.user:
        writer.writeByte(1);
        break;
      case RoleDto.assistant:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
