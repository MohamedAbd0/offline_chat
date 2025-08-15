import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class RenameChat {
  final ChatRepository repository;

  const RenameChat(this.repository);

  Future<Chat> call(int chatId, String title) async {
    return await repository.renameChat(chatId, title);
  }
}
