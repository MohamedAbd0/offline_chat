import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/settings.dart';
import '../../../domain/usecases/get_settings.dart';
import '../../../domain/usecases/update_settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings _getSettings;
  final UpdateSettings _updateSettings;

  SettingsBloc({
    required GetSettings getSettings,
    required UpdateSettings updateSettings,
  }) : _getSettings = getSettings,
       _updateSettings = updateSettings,
       super(const SettingsState()) {
    on<SettingsLoadRequested>(_onLoadRequested);
    on<SettingsSaved>(_onSaved);
  }

  Future<void> _onLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final settings = await _getSettings();
      emit(state.copyWith(settings: settings, isLoading: false));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> _onSaved(
    SettingsSaved event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isSaving: true));

    try {
      await _updateSettings(event.settings);
      emit(state.copyWith(settings: event.settings, isSaving: false));
    } catch (error) {
      emit(state.copyWith(isSaving: false, error: error.toString()));
    }
  }
}
