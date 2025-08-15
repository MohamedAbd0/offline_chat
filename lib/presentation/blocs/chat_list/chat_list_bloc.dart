import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat.dart';
import '../../../domain/usecases/create_chat.dart';
import '../../../domain/usecases/rename_chat.dart';
import '../../../domain/usecases/delete_chat.dart';
import '../../../domain/usecases/list_chats.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ListChats _listChats;
  final CreateChat _createChat;
  final RenameChat _renameChat;
  final DeleteChat _deleteChat;

  ChatListBloc({
    required ListChats listChats,
    required CreateChat createChat,
    required RenameChat renameChat,
    required DeleteChat deleteChat,
  }) : _listChats = listChats,
       _createChat = createChat,
       _renameChat = renameChat,
       _deleteChat = deleteChat,
       super(const ChatListState()) {
    on<ChatListLoadRequested>(_onLoadRequested);
    on<ChatListSearchChanged>(_onSearchChanged);
    on<ChatListChatCreated>(_onChatCreated);
    on<ChatListChatRenamed>(_onChatRenamed);
    on<ChatListChatDeleted>(_onChatDeleted);
  }

  Future<void> _onLoadRequested(
    ChatListLoadRequested event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final chats = await _listChats(
        query: state.searchQuery.isEmpty ? null : state.searchQuery,
      );
      emit(state.copyWith(chats: chats, isLoading: false));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> _onSearchChanged(
    ChatListSearchChanged event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query, isLoading: true));

    try {
      final chats = await _listChats(
        query: event.query.isEmpty ? null : event.query,
      );
      emit(state.copyWith(chats: chats, isLoading: false));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> _onChatCreated(
    ChatListChatCreated event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      final chat = await _createChat(event.title);
      final updatedChats = [chat, ...state.chats];
      emit(state.copyWith(chats: updatedChats));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<void> _onChatRenamed(
    ChatListChatRenamed event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      final updatedChat = await _renameChat(event.chatId, event.newTitle);
      final updatedChats = state.chats.map((chat) {
        return chat.id == event.chatId ? updatedChat : chat;
      }).toList();
      emit(state.copyWith(chats: updatedChats));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<void> _onChatDeleted(
    ChatListChatDeleted event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      await _deleteChat(event.chatId);
      final updatedChats = state.chats
          .where((chat) => chat.id != event.chatId)
          .toList();
      emit(state.copyWith(chats: updatedChats));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }
}
