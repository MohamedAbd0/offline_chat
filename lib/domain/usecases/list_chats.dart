import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class ListChats {
  final ChatRepository repository;

  const ListChats(this.repository);

  Future<List<Chat>> call({String? query}) async {
    return await repository.listChats(query: query);
  }
}
