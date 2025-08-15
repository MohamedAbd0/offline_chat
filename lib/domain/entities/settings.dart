import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final String baseUrl;
  final String fixedModel;
  final String keepAlive;
  final bool visionEnabled;

  const Settings({
    required this.baseUrl,
    required this.fixedModel,
    required this.keepAlive,
    required this.visionEnabled,
  });

  Settings copyWith({
    String? baseUrl,
    String? fixedModel,
    String? keepAlive,
    bool? visionEnabled,
  }) {
    return Settings(
      baseUrl: baseUrl ?? this.baseUrl,
      fixedModel: fixedModel ?? this.fixedModel,
      keepAlive: keepAlive ?? this.keepAlive,
      visionEnabled: visionEnabled ?? this.visionEnabled,
    );
  }

  @override
  List<Object> get props => [baseUrl, fixedModel, keepAlive, visionEnabled];
}
