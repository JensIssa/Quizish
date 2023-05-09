
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/FireServices/UserService.dart';
import 'package:quizish/bloc/AppEvent.dart';
import 'package:quizish/bloc/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthService _authService;
  StreamSubscription<User>? _authSubscription;

  AppBloc({required AuthService authService})
      : _authService = authService,
        super(
        authService.currentUser.isNotEmpty
            ? AppState.authenticated(authService.currentUser)
            : const AppState.unauthenticated(),
          ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogOutRequested>(_onLogOutRequested);
  }

  void _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
      )
     {}

  void _onLogOutRequested(
    AppLogOutRequested event,
    Emitter<AppState> emit,
    ) {}

}