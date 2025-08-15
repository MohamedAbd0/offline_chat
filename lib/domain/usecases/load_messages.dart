import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class LoadMessages {
  final ChatRepository repository;

  const LoadMessages(this.repository);

  Future<List<Message>> call(
    int chatId, {
    int pageSize = 32,
    int? beforeMessageId,
  }) async {
    return await repository.loadMessages(
      chatId,
      pageSize: pageSize,
      beforeMessageId: beforeMessageId,
    );
  }
}
