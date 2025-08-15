import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/settings/settings_bloc.dart';
import '../../domain/entities/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _baseUrlController = TextEditingController();
  final _modelController = TextEditingController();
  final _keepAliveController = TextEditingController();
  bool _visionEnabled = false;

  @override
  void dispose() {
    _baseUrlController.dispose();
    _modelController.dispose();
    _keepAliveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state.settings != null) {
            _baseUrlController.text = state.settings!.baseUrl;
            _modelController.text = state.settings!.fixedModel;
            _keepAliveController.text = state.settings!.keepAlive;
            _visionEnabled = state.settings!.visionEnabled;
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  ElevatedButton(
                    onPressed: () => context.read<SettingsBloc>().add(
                      const SettingsLoadRequested(),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _baseUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Ollama Base URL',
                    hintText: 'http://localhost:11434',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'Model Name',
                    hintText: 'llama3.2:3b',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _keepAliveController,
                  decoration: const InputDecoration(
                    labelText: 'Keep Alive',
                    hintText: '5m',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Vision Enabled'),
                  subtitle: const Text('Enable image processing capabilities'),
                  value: _visionEnabled,
                  onChanged: (value) {
                    setState(() {
                      _visionEnabled = value;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: state.isSaving ? null : _saveSettings,
                  child: state.isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Save Settings'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveSettings() {
    final settings = Settings(
      baseUrl: _baseUrlController.text.trim(),
      fixedModel: _modelController.text.trim(),
      keepAlive: _keepAliveController.text.trim(),
      visionEnabled: _visionEnabled,
    );

    context.read<SettingsBloc>().add(SettingsSaved(settings));
  }
}
