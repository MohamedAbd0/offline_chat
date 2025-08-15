import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:offline_chat/exports.dart';


final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  final config = await AppConfig.load();
  getIt.registerSingleton<AppConfig>(config);

  // External
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: getIt<AppConfig>().baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
  );

  // Data sources
  final db = await HiveDb.open();
  getIt.registerSingleton<HiveDb>(db);

  getIt.registerLazySingleton<OllamaApi>(
    () => OllamaApi(dio: getIt<Dio>(), config: getIt<AppConfig>()),
  );

  // Repository
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt<HiveDb>(), getIt<OllamaApi>()),
  );

  // Use cases
  getIt.registerFactory(() => CreateChat(getIt<ChatRepository>()));
  getIt.registerFactory(() => RenameChat(getIt<ChatRepository>()));
  getIt.registerFactory(() => DeleteChat(getIt<ChatRepository>()));
  getIt.registerFactory(() => ListChats(getIt<ChatRepository>()));
  getIt.registerFactory(() => LoadMessages(getIt<ChatRepository>()));
  getIt.registerFactory(() => SendUserMessage(getIt<ChatRepository>()));
  getIt.registerFactory(() => StopStreaming(getIt<ChatRepository>()));
  getIt.registerFactory(() => GenerateTitle(getIt<ChatRepository>()));
  getIt.registerFactory(() => GetSettings(getIt<ChatRepository>()));
  getIt.registerFactory(() => UpdateSettings(getIt<ChatRepository>()));

  // BLoCs
  getIt.registerFactory(
    () => ChatListBloc(
      listChats: getIt<ListChats>(),
      createChat: getIt<CreateChat>(),
      renameChat: getIt<RenameChat>(),
      deleteChat: getIt<DeleteChat>(),
    ),
  );

  getIt.registerFactoryParam<ChatRoomBloc, int, void>(
    (chatId, _) => ChatRoomBloc(
      chatId: chatId,
      loadMessages: getIt<LoadMessages>(),
      sendUserMessage: getIt<SendUserMessage>(),
      stopStreaming: getIt<StopStreaming>(),
      generateTitle: getIt<GenerateTitle>(),
    ),
  );

  getIt.registerFactory(
    () => SettingsBloc(
      getSettings: getIt<GetSettings>(),
      updateSettings: getIt<UpdateSettings>(),
    ),
  );
}
