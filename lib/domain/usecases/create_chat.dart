import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class CreateChat {
  final ChatRepository repository;

  const CreateChat(this.repository);

  Future<Chat> call([String? title]) async {
    return await repository.createChat(title ?? 'New chat');
  }
}
