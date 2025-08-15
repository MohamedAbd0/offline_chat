import '../repositories/chat_repository.dart';

class GenerateTitle {
  final ChatRepository repository;

  const GenerateTitle(this.repository);

  Future<String> call(int chatId) async {
    return await repository.generateTitle(chatId);
  }
}
