
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/bloc/login_bloc/LoginState.dart';

class LoginCubit extends Cubit<LoginState>{
  final AuthService _authService;

  LoginCubit(this._authService) : super(LoginState.initial());

  /**
   * This method is called when the user changes the email
   */
  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  /**
   *This method is called when the user changes the password
   */
  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  /**
   * This method logs in with credentials provided by the user
   */
  Future<void> logInWithCredentials() async {
    if (state.status == LoginStatus.submitting)
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authService.loginWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.succes));
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
  }
