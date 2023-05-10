
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/bloc/LoginState.dart';

class LoginCubit extends Cubit<LoginState>{
  final AuthService _authService;

  LoginCubit(this._authService) : super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }
  Future<void> logInWithCredentials() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authService.loginWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.succes));
    } catch (_) {}
  }
  }
