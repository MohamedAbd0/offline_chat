import 'package:dio/dio.dart';
import '../repositories/chat_repository.dart';

class SendUserMessage {
  final ChatRepository repository;

  const SendUserMessage(this.repository);

  Stream<String> call({
    required int chatId,
    required String text,
    List<String>? attachments,
    CancelToken? cancelToken,
  }) {
    return repository.sendUserMessage(
      chatId: chatId,
      text: text,
      attachments: attachments ?? [],
      cancelToken: cancelToken,
    );
  }
}
