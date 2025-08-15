import '../entities/settings.dart';
import '../repositories/chat_repository.dart';

class UpdateSettings {
  final ChatRepository repository;

  const UpdateSettings(this.repository);

  Future<void> call(Settings settings) async {
    return await repository.updateSettings(settings);
  }
}
