import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/injector.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/blocs/chat_list/chat_list_bloc.dart';
import 'presentation/blocs/settings/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependency injection
  await configureDependencies();

  runApp(const OfflineChatApp());
}

class OfflineChatApp extends StatelessWidget {
  const OfflineChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<ChatListBloc>()..add(const ChatListLoadRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<SettingsBloc>()..add(const SettingsLoadRequested()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Offline Chat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
