part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final Settings? settings;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  const SettingsState({
    this.settings,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  SettingsState copyWith({
    Settings? settings,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  @override
  List<Object?> get props => [settings, isLoading, isSaving, error];
}
