import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/blocs/blocs.dart';
import 'package:shop/blocs/chat/chat_bloc.dart';
import 'package:shop/blocs/user/user_bloc.dart';
import 'package:shop/cubits/cubits.dart';
import 'package:shop/repositories/auth/auth_repository.dart';
import 'package:shop/repositories/chat/chat_repository.dart';
import 'package:shop/repositories/chat_message/chat_message_repository.dart';
import 'package:shop/repositories/user/user_repository.dart';
import 'package:shop/screens/chat/chat_screen.dart';
import 'package:shop/screens/guest/guest_screen.dart';
import 'package:shop/screens/screens.dart';
import 'package:shop/screens/splash/splash_screen.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<ChatRepository>(
          create: (_) => ChatRepository(),
        ),
        RepositoryProvider<ChatMessageRepository>(
          create: (_) => ChatMessageRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(
            create: (context) => GuestCubit(
              authRepository: context.read<AuthRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChatBloc(
              chatRepository: context.read<ChatRepository>(),
              chatMessageRepository: context.read<ChatMessageRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                UserBloc(userRepository: context.read<UserRepository>()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: GuestScreen.routeName,
          routes: {
            SplashScreen.routeName: (_) => const SplashScreen(),
            GuestScreen.routeName: (_) => const GuestScreen(),
            ChatListScreen.routeName: (_) => const ChatListScreen(),
            ChatScreen.routeName: (_) => const ChatScreen(),
          },
        ),
      ),
    );
  }
}