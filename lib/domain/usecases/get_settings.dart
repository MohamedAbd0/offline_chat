import '../entities/settings.dart';
import '../repositories/chat_repository.dart';

class GetSettings {
  final ChatRepository repository;

  const GetSettings(this.repository);

  Future<Settings> call() async {
    return await repository.getSettings();
  }
}
