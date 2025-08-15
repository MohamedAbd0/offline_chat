import '../../domain/entities/settings.dart';
import '../dtos/settings_dto.dart';

class SettingsMapper {
  static Settings toEntity(SettingsDto dto) {
    return Settings(
      baseUrl: dto.baseUrl,
      fixedModel: dto.fixedModel,
      keepAlive: dto.keepAlive,
      visionEnabled: dto.visionEnabled,
    );
  }

  static SettingsDto toDto(Settings entity) {
    return SettingsDto.fromValues(
      baseUrl: entity.baseUrl,
      fixedModel: entity.fixedModel,
      keepAlive: entity.keepAlive,
      visionEnabled: entity.visionEnabled,
    );
  }
}
