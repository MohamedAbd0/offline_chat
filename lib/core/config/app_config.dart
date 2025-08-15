import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String baseUrl;
  final String fixedModel;
  final String keepAlive;
  final bool visionEnabled;

  const AppConfig({
    required this.baseUrl,
    required this.fixedModel,
    required this.keepAlive,
    required this.visionEnabled,
  });

  static Future<AppConfig> load() async {
    try {
      final configString = await rootBundle.loadString(
        'assets/config/app_config.json',
      );
      final configMap = json.decode(configString) as Map<String, dynamic>;

      return AppConfig(
        baseUrl: configMap['baseUrl'] as String? ?? 'http://localhost:11434',
        fixedModel: configMap['fixedModel'] as String? ?? 'llama3.2:3b',
        keepAlive: configMap['keepAlive'] as String? ?? '5m',
        visionEnabled: configMap['visionEnabled'] as bool? ?? true,
      );
    } catch (e) {
      // Fallback to default values if config file doesn't exist or is invalid
      return const AppConfig(
        baseUrl: 'http://localhost:11434',
        fixedModel: 'llama3.2:3b',
        keepAlive: '5m',
        visionEnabled: true,
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'baseUrl': baseUrl,
    'fixedModel': fixedModel,
    'keepAlive': keepAlive,
    'visionEnabled': visionEnabled,
  };

  AppConfig copyWith({
    String? baseUrl,
    String? fixedModel,
    String? keepAlive,
    bool? visionEnabled,
  }) {
    return AppConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      fixedModel: fixedModel ?? this.fixedModel,
      keepAlive: keepAlive ?? this.keepAlive,
      visionEnabled: visionEnabled ?? this.visionEnabled,
    );
  }
}
