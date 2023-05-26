import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/bloc/AppEvent.dart';
import 'package:quizish/bloc/app_state.dart';
import '../models/User.dart';

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

    _authSubscription = _authService.user.listen((user) =>
        add(AppUserChanged(user)),);
  }

  /**
   * This method is called when the user changes
   */
  void _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    emit(event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated());
  }

  /**
   * This method is called when the user logs out
   */
  void _onLogOutRequested(
    AppLogOutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_authService.logOut());
  }

  /**
   * This method closes the stream subscription
   */
  @override
  Future<void> close() {
  _authSubscription?.cancel();
  return super.close();
  }
}
