import '../repositories/chat_repository.dart';

class DeleteChat {
  final ChatRepository repository;

  const DeleteChat(this.repository);

  Future<void> call(int chatId) async {
    return await repository.deleteChat(chatId);
  }
}
