import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/bloc/register_bloc/RegisterState.dart';

import '../../FireServices/AuthService.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService;

  RegisterCubit(this._authService) : super(RegisterState.initial());


  /**
   * This method is called when the user changes the email
   */
  void emailChanged(String value) {
    emit(
        state.copyWith
          (
          email: value,
          status: RegisterStatus.initial,
        ),
    );
  }

  /**
   * This method is called when the user changes the password
   */
  void passwordChanged(String value) {
    emit(state.copyWith
      (password: value,
        status: RegisterStatus.initial,
      ),
    );
  }

  /**
   * This method is called when the user changes the display name
   */
  void displayNameChanged(String value){
    emit(state.copyWith
      (displayName: value,
        status: RegisterStatus.initial,
      ),
    );
  }

  /**
   * This method registers the user with credentials provided by the user
   */
  Future<void> registerFormSubmitted() async {
    if (state.status == RegisterStatus.submitting) {
      emit(state.copyWith(status: RegisterStatus.submitting));
    }
    try {
      await _authService.signUp(email: state.email, password: state.password, displayName: state.displayName);
          emit(state.copyWith(status: RegisterStatus.success));
    } catch (_) {
      emit(state.copyWith(status: RegisterStatus.error));
    }
  }

}
