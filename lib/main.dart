import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:quizish/Screens/GameSessionProvider.dart';
import 'package:quizish/Screens/in_app_container.dart';
import 'package:quizish/Screens/join_screen.dart';
import 'package:quizish/Screens/quiz_screen.dart';
import 'package:quizish/Screens/scoboard_screen.dart';
import 'package:quizish/Screens/homescreen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/bloc/AppBloc.dart';
import 'package:quizish/bloc/routes.dart';
import 'package:quizish/firebase_options.dart';
import 'package:quizish/provider/quiz_notifier_model.dart';
import 'Screens/login_screen.dart';
import 'bloc_observer.dart';




Future<void> main() {
  return BlocOverrides.runZoned(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        
        final themeStr = await rootBundle.loadString('assets/theme.json');
        final themeJson = json.decode(themeStr);
        final theme = ThemeDecoder.decodeThemeData(themeJson)!;

        
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
        );
        final authService = AuthService();
        runApp(MyApp(theme: theme, authService: authService));
      },
    blocObserver: AppBlocObserver(),
  );
}

/**
 * My app class, this is the root of the app
 * Uses MultiProvider to provide the GameSessionProvider and QuizNotifierModel
 */

class MyApp extends StatelessWidget {
  final ThemeData theme;


  const MyApp({Key? key, required this.theme, required AuthService authService})
      : _authService = authService, super(key: key);

  final AuthService _authService;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GameSessionProvider>(
          create: (_) => GameSessionProvider(),
        ),
        ChangeNotifierProvider<QuizNotifierModel>(
          create: (_) => QuizNotifierModel(),
        ),
      ],
      child: RepositoryProvider.value(
        value: _authService,
        child: BlocProvider(
          create: (_) => AppBloc(authService: _authService),
          child: AppView(theme: theme,)
        ),
      )
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();


/**
 * AppView class
 * This is the main view of the app
 * It uses FlowBuilder to build the app
 */
class AppView extends StatelessWidget {
  const AppView({Key? key, required this.theme}) : super(key: key);
  final ThemeData theme;
  
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      initialRoute: "/",
      routes: {
        "/home": (context) => InAppContainer(),
      },
      navigatorKey: navigatorKey,
      theme: theme,
      home: FlowBuilder(
          state: context.select((AppBloc bloc) => bloc.state),
          onGeneratePages: onGenerateAppViewPages),
    );
  }
}

