import 'package:hive/hive.dart';

part 'settings_dto.g.dart';

@HiveType(typeId: 5)
class SettingsDto extends HiveObject {
  @HiveField(0)
  late String baseUrl;

  @HiveField(1)
  late String fixedModel;

  @HiveField(2)
  late String keepAlive;

  @HiveField(3)
  late bool visionEnabled;

  SettingsDto();

  SettingsDto.fromValues({
    required this.baseUrl,
    required this.fixedModel,
    required this.keepAlive,
    required this.visionEnabled,
  });
}
