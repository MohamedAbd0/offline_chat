import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/errors.dart';
import '../../dtos/chat_dto.dart';
import '../../dtos/message_dto.dart';
import '../../dtos/attachment_dto.dart';
import '../../dtos/settings_dto.dart';

class HiveDb {
  static const String _chatsBoxName = 'chats';
  static const String _messagesBoxName = 'messages';
  static const String _attachmentsBoxName = 'attachments';
  static const String _settingsBoxName = 'settings';

  late Box<ChatDto> _chatsBox;
  late Box<MessageDto> _messagesBox;
  late Box<AttachmentDto> _attachmentsBox;
  late Box<SettingsDto> _settingsBox;

  static Future<HiveDb> open() async {
    final db = HiveDb._();
    await db._initialize();
    return db;
  }

  HiveDb._();

  Future<void> _initialize() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ChatDtoAdapter());
    Hive.registerAdapter(MessageDtoAdapter());
    Hive.registerAdapter(RoleDtoAdapter());
    Hive.registerAdapter(AttachmentDtoAdapter());
    Hive.registerAdapter(AttachmentTypeDtoAdapter());
    Hive.registerAdapter(SettingsDtoAdapter());

    // Open boxes
    _chatsBox = await Hive.openBox<ChatDto>(_chatsBoxName);
    _messagesBox = await Hive.openBox<MessageDto>(_messagesBoxName);
    _attachmentsBox = await Hive.openBox<AttachmentDto>(_attachmentsBoxName);
    _settingsBox = await Hive.openBox<SettingsDto>(_settingsBoxName);
  }

  // ID generation helpers
  int _generateChatId() {
    final keys = _chatsBox.keys.cast<int>();
    return keys.isEmpty ? 1 : keys.reduce((a, b) => a > b ? a : b) + 1;
  }

  int _generateMessageId() {
    final keys = _messagesBox.keys.cast<int>();
    return keys.isEmpty ? 1 : keys.reduce((a, b) => a > b ? a : b) + 1;
  }

  int _generateAttachmentId() {
    final keys = _attachmentsBox.keys.cast<int>();
    return keys.isEmpty ? 1 : keys.reduce((a, b) => a > b ? a : b) + 1;
  }

  // Chat operations
  Future<ChatDto> createChat(ChatDto chat) async {
    try {
      final id = _generateChatId();
      chat.id = id;
      await _chatsBox.put(id, chat);
      return chat;
    } catch (e) {
      throw DatabaseException('Failed to create chat: $e');
    }
  }

  Future<ChatDto> updateChat(ChatDto chat) async {
    try {
      await _chatsBox.put(chat.id, chat);
      return chat;
    } catch (e) {
      throw DatabaseException('Failed to update chat: $e');
    }
  }

  Future<void> deleteChat(int chatId) async {
    try {
      // Delete messages and attachments first
      final messages = _messagesBox.values
          .where((message) => message.chatId == chatId)
          .toList();

      for (final message in messages) {
        final attachments = _attachmentsBox.values
            .where((attachment) => attachment.messageId == message.id)
            .toList();

        for (final attachment in attachments) {
          await _attachmentsBox.delete(attachment.id);
        }

        await _messagesBox.delete(message.id);
      }

      await _chatsBox.delete(chatId);
    } catch (e) {
      throw DatabaseException('Failed to delete chat: $e');
    }
  }

  Future<List<ChatDto>> listChats({String? query}) async {
    try {
      var chats = _chatsBox.values.toList();

      if (query != null && query.isNotEmpty) {
        chats = chats
            .where(
              (chat) => chat.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }

      chats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return chats;
    } catch (e) {
      throw DatabaseException('Failed to list chats: $e');
    }
  }

  Future<ChatDto?> getChat(int chatId) async {
    try {
      return _chatsBox.get(chatId);
    } catch (e) {
      throw DatabaseException('Failed to get chat: $e');
    }
  }

  // Message operations
  Future<MessageDto> saveMessage(MessageDto message) async {
    try {
      final id = _generateMessageId();
      message.id = id;
      await _messagesBox.put(id, message);
      return message;
    } catch (e) {
      throw DatabaseException('Failed to save message: $e');
    }
  }

  Future<MessageDto> updateMessage(MessageDto message) async {
    try {
      await _messagesBox.put(message.id, message);
      return message;
    } catch (e) {
      throw DatabaseException('Failed to update message: $e');
    }
  }

  Future<List<MessageDto>> loadMessages(
    int chatId, {
    int pageSize = 32,
    int? beforeMessageId,
  }) async {
    try {
      var messages = _messagesBox.values
          .where((message) => message.chatId == chatId)
          .toList();

      if (beforeMessageId != null) {
        messages = messages
            .where((message) => message.id < beforeMessageId)
            .toList();
      }

      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return messages.take(pageSize).toList();
    } catch (e) {
      throw DatabaseException('Failed to load messages: $e');
    }
  }

  Future<void> deleteMessage(int messageId) async {
    try {
      final attachments = _attachmentsBox.values
          .where((attachment) => attachment.messageId == messageId)
          .toList();

      for (final attachment in attachments) {
        await _attachmentsBox.delete(attachment.id);
      }

      await _messagesBox.delete(messageId);
    } catch (e) {
      throw DatabaseException('Failed to delete message: $e');
    }
  }

  // Attachment operations
  Future<AttachmentDto> saveAttachment(AttachmentDto attachment) async {
    try {
      final id = _generateAttachmentId();
      attachment.id = id;
      await _attachmentsBox.put(id, attachment);
      return attachment;
    } catch (e) {
      throw DatabaseException('Failed to save attachment: $e');
    }
  }

  Future<List<AttachmentDto>> getMessageAttachments(int messageId) async {
    try {
      return _attachmentsBox.values
          .where((attachment) => attachment.messageId == messageId)
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to get attachments: $e');
    }
  }

  Future<void> deleteAttachment(int attachmentId) async {
    try {
      await _attachmentsBox.delete(attachmentId);
    } catch (e) {
      throw DatabaseException('Failed to delete attachment: $e');
    }
  }

  // Settings operations
  Future<SettingsDto?> getSettings() async {
    try {
      const settingsKey = 'app_settings';
      return _settingsBox.get(settingsKey);
    } catch (e) {
      throw DatabaseException('Failed to get settings: $e');
    }
  }

  Future<void> saveSettings(SettingsDto settings) async {
    try {
      const settingsKey = 'app_settings';
      await _settingsBox.put(settingsKey, settings);
    } catch (e) {
      throw DatabaseException('Failed to save settings: $e');
    }
  }

  Future<void> close() async {
    await _chatsBox.close();
    await _messagesBox.close();
    await _attachmentsBox.close();
    await _settingsBox.close();
  }
}
