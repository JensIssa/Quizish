import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
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
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
        );
        final authService = AuthService();
        runApp(MyApp(authService: authService));
      },
    blocObserver: AppBlocObserver(),
  );
}



class MyApp extends StatelessWidget {

  const MyApp({Key? key, required AuthService authService}) : _authService = authService, super(key: key);

  final AuthService _authService;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(value: _authService,
      child: BlocProvider(
        create: (_) => AppBloc(authService: _authService),
        child: AppView(),
      ),
    );
  }
  
}
class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: FlowBuilder(
          state: context.select((AppBloc bloc) => bloc.state),
          onGeneratePages: onGenerateAppViewPages),
    );
  }
}

