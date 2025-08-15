// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_chat/domain/entities/settings.dart';

import '../blocs/settings/settings_bloc.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final _baseUrlController = TextEditingController();
  final _modelController = TextEditingController();
  final _keepAliveController = TextEditingController();
  bool _visionEnabled = false;
  bool _wasSaving = false;

  @override
  void dispose() {
    _baseUrlController.dispose();
    _modelController.dispose();
    _keepAliveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state.settings != null) {
          _baseUrlController.text = state.settings!.baseUrl;
          _modelController.text = state.settings!.fixedModel;
          _keepAliveController.text = state.settings!.keepAlive;
          setState(() {
            _visionEnabled = state.settings!.visionEnabled;
          });
        }

        // If was saving and now not saving, it means save completed
        if (_wasSaving && !state.isSaving && state.error == null) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings saved successfully!')),
          );
        }

        _wasSaving = state.isSaving;
      },
      builder: (context, state) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              const Text('Settings'),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (state.error != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Error: ${state.error}',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => context.read<SettingsBloc>().add(
                              const SettingsLoadRequested(),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    TextField(
                      controller: _baseUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Ollama Base URL',
                        hintText: 'http://localhost:11434',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Model Name',
                        hintText: 'gemma3:4b',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.psychology),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _keepAliveController,
                      decoration: const InputDecoration(
                        labelText: 'Keep Alive',
                        hintText: '5m',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.schedule),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SwitchListTile(
                        title: const Text('Vision Enabled'),
                        subtitle: const Text(
                          'Enable image processing capabilities',
                        ),
                        value: _visionEnabled,
                        onChanged: (value) {
                          setState(() {
                            _visionEnabled = value;
                          });
                        },
                        secondary: const Icon(Icons.visibility),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: state.isLoading || state.isSaving
                  ? null
                  : () => _saveSettings(context),
              child: state.isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveSettings(BuildContext context) {
    final settings = Settings(
      baseUrl: _baseUrlController.text.trim(),
      fixedModel: _modelController.text.trim(),
      keepAlive: _keepAliveController.text.trim(),
      visionEnabled: _visionEnabled,
    );

    context.read<SettingsBloc>().add(SettingsSaved(settings));
  }
}
