import '../repositories/chat_repository.dart';

class StopStreaming {
  final ChatRepository repository;

  const StopStreaming(this.repository);

  Future<void> call(int chatId) async {
    return await repository.stopStreaming(chatId);
  }
}
