// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttachmentDtoAdapter extends TypeAdapter<AttachmentDto> {
  @override
  final int typeId = 3;

  @override
  AttachmentDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttachmentDto()
      ..id = fields[0] as int
      ..messageId = fields[1] as int
      ..type = fields[2] as AttachmentTypeDto
      ..path = fields[3] as String
      ..displayName = fields[4] as String
      ..bytesLength = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, AttachmentDto obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.messageId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.displayName)
      ..writeByte(5)
      ..write(obj.bytesLength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttachmentTypeDtoAdapter extends TypeAdapter<AttachmentTypeDto> {
  @override
  final int typeId = 4;

  @override
  AttachmentTypeDto read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AttachmentTypeDto.image;
      case 1:
        return AttachmentTypeDto.text;
      case 2:
        return AttachmentTypeDto.pdf;
      default:
        return AttachmentTypeDto.image;
    }
  }

  @override
  void write(BinaryWriter writer, AttachmentTypeDto obj) {
    switch (obj) {
      case AttachmentTypeDto.image:
        writer.writeByte(0);
        break;
      case AttachmentTypeDto.text:
        writer.writeByte(1);
        break;
      case AttachmentTypeDto.pdf:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentTypeDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
