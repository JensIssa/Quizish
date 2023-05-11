import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
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



class MyApp extends StatelessWidget {
  final ThemeData theme;


  const MyApp({Key? key, required this.theme, required AuthService authService}) : _authService = authService, super(key: key);

  final AuthService _authService;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return RepositoryProvider.value(value: _authService,
      child: BlocProvider(
        create: (_) => AppBloc(authService: _authService),
        child: AppView(theme: theme,),
      ),

    );
  }
  
}
class AppView extends StatelessWidget {
  const AppView({Key? key, required this.theme}) : super(key: key);
  final ThemeData theme;
  
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: theme,
      home: FlowBuilder(
          state: context.select((AppBloc bloc) => bloc.state),
          onGeneratePages: onGenerateAppViewPages),
    );
  }
}

