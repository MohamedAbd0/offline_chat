import 'package:dio/dio.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/attachment.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/hive_db.dart';
import '../datasources/remote/ollama_api.dart';
import '../dtos/chat_dto.dart';
import '../dtos/settings_dto.dart';
import '../mappers/chat_mapper.dart';
import '../mappers/message_mapper.dart';
import '../mappers/attachment_mapper.dart';
import '../mappers/settings_mapper.dart';

class ChatRepositoryImpl implements ChatRepository {
  final HiveDb _db;
  final OllamaApi _api; // Will be used for actual API integration

  ChatRepositoryImpl(this._db, this._api);

  @override
  Future<Chat> createChat(String title) async {
    final chatDto = ChatDto.fromValues(
      id: 0, // Will be set by the database
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final savedDto = await _db.createChat(chatDto);
    return ChatMapper.toEntity(savedDto);
  }

  @override
  Future<Chat> renameChat(int chatId, String title) async {
    final chatDto = await _db.getChat(chatId);
    if (chatDto == null) {
      throw Exception('Chat not found');
    }

    chatDto.title = title;
    chatDto.updatedAt = DateTime.now();
    final savedDto = await _db.updateChat(chatDto);
    return ChatMapper.toEntity(savedDto);
  }

  @override
  Future<void> deleteChat(int chatId) async {
    await _db.deleteChat(chatId);
  }

  @override
  Future<List<Chat>> listChats({String? query}) async {
    final chatDtos = await _db.listChats(query: query);
    return ChatMapper.toEntityList(chatDtos);
  }

  @override
  Future<Chat?> getChat(int chatId) async {
    final chatDto = await _db.getChat(chatId);
    return chatDto != null ? ChatMapper.toEntity(chatDto) : null;
  }

  @override
  Future<List<Message>> loadMessages(
    int chatId, {
    int pageSize = 32,
    int? beforeMessageId,
  }) async {
    final messageDtos = await _db.loadMessages(
      chatId,
      pageSize: pageSize,
      beforeMessageId: beforeMessageId,
    );
    return MessageMapper.toEntityList(messageDtos);
  }

  @override
  Future<Message> saveMessage(Message message) async {
    final messageDto = MessageMapper.toDto(message);
    final savedDto = await _db.saveMessage(messageDto);
    return MessageMapper.toEntity(savedDto);
  }

  @override
  Future<Message> updateMessage(Message message) async {
    final messageDto = MessageMapper.toDto(message);
    final savedDto = await _db.updateMessage(messageDto);
    return MessageMapper.toEntity(savedDto);
  }

  @override
  Future<void> deleteMessage(int messageId) async {
    await _db.deleteMessage(messageId);
  }

  @override
  Future<Attachment> saveAttachment(Attachment attachment) async {
    final attachmentDto = AttachmentMapper.toDto(attachment);
    final savedDto = await _db.saveAttachment(attachmentDto);
    return AttachmentMapper.toEntity(savedDto);
  }

  @override
  Future<List<Attachment>> getMessageAttachments(int messageId) async {
    final attachmentDtos = await _db.getMessageAttachments(messageId);
    return AttachmentMapper.toEntityList(attachmentDtos);
  }

  @override
  Future<void> deleteAttachment(int attachmentId) async {
    await _db.deleteAttachment(attachmentId);
  }

  @override
  Stream<String> sendUserMessage({
    required int chatId,
    required String text,
    required List<String> attachments,
    CancelToken? cancelToken,
  }) async* {
    try {
      // Create user message
      final userMessage = Message(
        id: 0, // Will be set by the database
        chatId: chatId,
        role: Role.user,
        content: text,
        createdAt: DateTime.now(),
        hasError: false,
      );

      await saveMessage(userMessage);

      // Create assistant message placeholder
      final assistantMessage = Message(
        id: 0, // Will be set by the database
        chatId: chatId,
        role: Role.assistant,
        content: '',
        createdAt: DateTime.now(),
        hasError: false,
      );

      final savedAssistantMessage = await saveMessage(assistantMessage);

      // Get conversation history
      final messages = await loadMessages(chatId);

      // Filter out the empty assistant message for the API call
      final historyForApi = messages
          .where((m) => !(m.role == Role.assistant && m.content.isEmpty))
          .toList()
          .reversed
          .toList(); // Reverse to get chronological order

      // Stream the response from Ollama API
      String fullResponse = '';

      await for (final chunk in _api.chatStream(
        history: historyForApi,
        cancelToken: cancelToken,
      )) {
        fullResponse += chunk;
        yield chunk;

        // Update the assistant message in the database with current content
        final updatedAssistantMessage = savedAssistantMessage.copyWith(
          content: fullResponse,
        );
        await updateMessage(updatedAssistantMessage);
      }

      // Update chat timestamp
      final chat = await getChat(chatId);
      if (chat != null) {
        await renameChat(chatId, chat.title); // This will update the timestamp
      }
    } catch (e) {
      // Handle errors by creating an error message
      final errorMessage = Message(
        id: 0,
        chatId: chatId,
        role: Role.assistant,
        content: 'Error: Failed to get response from AI model. ${e.toString()}',
        createdAt: DateTime.now(),
        hasError: true,
      );

      await saveMessage(errorMessage);

      // Re-throw to let the bloc handle it
      rethrow;
    }
  }

  @override
  Future<void> stopStreaming(int chatId) async {
    // Implementation for stopping streaming
    // This would need to be handled at the API level
  }

  @override
  Future<String> generateTitle(int chatId) async {
    final messages = await loadMessages(chatId);
    if (messages.isEmpty) return 'New Chat';

    final firstUserMessage = messages.firstWhere(
      (m) => m.role == Role.user,
      orElse: () => messages.first,
    );

    // Use first few words as title
    final words = firstUserMessage.content.split(' ').take(5).join(' ');
    final newTitle = words.isNotEmpty ? words : 'New Chat';

    // Actually update the chat title in the database
    if (newTitle != 'New Chat') {
      await renameChat(chatId, newTitle);
    }

    return newTitle;
  }

  @override
  Future<Settings> getSettings() async {
    final settingsDto = await _db.getSettings();
    if (settingsDto == null) {
      // Create default settings
      final defaultSettings = SettingsDto.fromValues(
        baseUrl: 'http://localhost:11434',
        fixedModel: 'llama3.2',
        keepAlive: '5m',
        visionEnabled: false,
      );

      await _db.saveSettings(defaultSettings);
      return SettingsMapper.toEntity(defaultSettings);
    }
    return SettingsMapper.toEntity(settingsDto);
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    final settingsDto = SettingsMapper.toDto(settings);
    await _db.saveSettings(settingsDto);
  }
}
