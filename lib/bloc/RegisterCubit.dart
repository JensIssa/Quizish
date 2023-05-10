import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/bloc/RegisterState.dart';

import '../FireServices/AuthService.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService;

  RegisterCubit(this._authService) : super(RegisterState.initial());


  void emailChanged(String value) {
    emit(
        state.copyWith
          (
          email: value,
          status: RegisterStatus.initial,
        ),
    );
  }

  void passwordChanged(String value) {
    emit(state.copyWith
      (password: value,
        status: RegisterStatus.initial,
      ),
    );
  }

  Future<void> registerFormSubmitted() async {
    if (state.status == RegisterStatus.submitting) return;
    emit(state.copyWith(status: RegisterStatus.submitting));
    try {
      await _authService.signUp(email: state.email, password: state.password);
          emit(state.copyWith(status: RegisterStatus.success));
    } catch (_) {}
  }

}
