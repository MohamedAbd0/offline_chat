import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/usecases/load_messages.dart';
import '../../../domain/usecases/send_user_message.dart';
import '../../../domain/usecases/stop_streaming.dart';
import '../../../domain/usecases/generate_title.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final int chatId;
  final LoadMessages _loadMessages;
  final SendUserMessage _sendUserMessage;
  final StopStreaming _stopStreaming;
  final GenerateTitle _generateTitle;

  StreamSubscription<String>? _streamSubscription;
  CancelToken? _cancelToken;

  ChatRoomBloc({
    required this.chatId,
    required LoadMessages loadMessages,
    required SendUserMessage sendUserMessage,
    required StopStreaming stopStreaming,
    required GenerateTitle generateTitle,
  }) : _loadMessages = loadMessages,
       _sendUserMessage = sendUserMessage,
       _stopStreaming = stopStreaming,
       _generateTitle = generateTitle,
       super(ChatRoomState(chatId: chatId)) {
    on<ChatRoomHistoryLoaded>(_onHistoryLoaded);
    on<ChatRoomMessageSent>(_onMessageSent, transformer: droppable());
    on<ChatRoomStreamChunkArrived>(_onStreamChunkArrived);
    on<ChatRoomStreamCompleted>(_onStreamCompleted);
    on<ChatRoomStreamStopped>(_onStreamStopped);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _cancelToken?.cancel();
    return super.close();
  }

  Future<void> _onHistoryLoaded(
    ChatRoomHistoryLoaded event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final messages = await _loadMessages(chatId);
      emit(
        state.copyWith(
          messages: messages.reversed.toList(), // Reverse to show oldest first
          isLoading: false,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> _onMessageSent(
    ChatRoomMessageSent event,
    Emitter<ChatRoomState> emit,
  ) async {
    if (state.isStreaming) return;

    emit(state.copyWith(isStreaming: true, error: null));

    try {
      _cancelToken = CancelToken();
      String partialContent = '';

      final stream = _sendUserMessage(
        chatId: chatId,
        text: event.text,
        attachments: event.attachments,
        cancelToken: _cancelToken,
      );

      _streamSubscription = stream.listen(
        (chunk) {
          partialContent += chunk;
          add(ChatRoomStreamChunkArrived(partialContent));
        },
        onDone: () {
          add(const ChatRoomStreamCompleted());
        },
        onError: (error) {
          emit(state.copyWith(isStreaming: false, error: error.toString()));
        },
      );
    } catch (error) {
      emit(state.copyWith(isStreaming: false, error: error.toString()));
    }
  }

  Future<void> _onStreamChunkArrived(
    ChatRoomStreamChunkArrived event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(state.copyWith(currentPartialAssistantContent: event.content));
  }

  Future<void> _onStreamCompleted(
    ChatRoomStreamCompleted event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(
      state.copyWith(isStreaming: false, currentPartialAssistantContent: null),
    );

    // Reload messages to get the final saved content
    try {
      final messages = await _loadMessages(chatId);
      emit(state.copyWith(messages: messages.reversed.toList()));

      // Generate title if this was the first message
      if (messages.length <= 2) {
        await _generateTitle(chatId);
        emit(state.copyWith(titleGenerated: true));
      }
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<void> _onStreamStopped(
    ChatRoomStreamStopped event,
    Emitter<ChatRoomState> emit,
  ) async {
    _streamSubscription?.cancel();
    _cancelToken?.cancel();

    try {
      await _stopStreaming(chatId);
    } catch (_) {
      // Ignore errors when stopping
    }

    emit(
      state.copyWith(isStreaming: false, currentPartialAssistantContent: null),
    );

    // Reload messages to get any partial content that was saved
    try {
      final messages = await _loadMessages(chatId);
      emit(state.copyWith(messages: messages.reversed.toList()));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }
}
