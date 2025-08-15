part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsLoadRequested extends SettingsEvent {
  const SettingsLoadRequested();
}

class SettingsSaved extends SettingsEvent {
  final Settings settings;

  const SettingsSaved(this.settings);

  @override
  List<Object> get props => [settings];
}
