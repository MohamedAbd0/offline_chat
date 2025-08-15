import 'package:dio/dio.dart';
import '../entities/chat.dart';
import '../entities/message.dart';
import '../entities/attachment.dart';
import '../entities/settings.dart';

abstract class ChatRepository {
  // Chat operations
  Future<Chat> createChat(String title);
  Future<Chat> renameChat(int chatId, String title);
  Future<void> deleteChat(int chatId);
  Future<List<Chat>> listChats({String? query});
  Future<Chat?> getChat(int chatId);

  // Message operations
  Future<List<Message>> loadMessages(
    int chatId, {
    int pageSize = 32,
    int? beforeMessageId,
  });
  Future<Message> saveMessage(Message message);
  Future<Message> updateMessage(Message message);
  Future<void> deleteMessage(int messageId);

  // Attachment operations
  Future<Attachment> saveAttachment(Attachment attachment);
  Future<List<Attachment>> getMessageAttachments(int messageId);
  Future<void> deleteAttachment(int attachmentId);

  // Streaming operations
  Stream<String> sendUserMessage({
    required int chatId,
    required String text,
    required List<String> attachments,
    CancelToken? cancelToken,
  });

  Future<void> stopStreaming(int chatId);

  // Title generation
  Future<String> generateTitle(int chatId);

  // Settings operations
  Future<Settings> getSettings();
  Future<void> updateSettings(Settings settings);
}
