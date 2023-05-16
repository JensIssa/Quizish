import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/bloc/infochanged_bloc/InfoChange_State.dart';

import '../../FireServices/AuthService.dart';

class RegisterCubit extends Cubit<ChangeState> {
  final AuthService _authService;

  RegisterCubit(this._authService) : super(ChangeState.initial());


  void emailChanged(String value) {
    emit(
      state.copyWith
        (
        email: value,
        status: ChangeStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(state.copyWith
      (password: value,
      status: ChangeStatus.initial,
    ),
    );
  }
  void displayNameChanged(String value){
    emit(state.copyWith
      (displayName: value,
      status: ChangeStatus.initial,
    ),
    );
  }

  Future<void> registerFormSubmitted() async {
    if (state.status == ChangeStatus.submitting) {
      emit(state.copyWith(status: ChangeStatus.submitting));
    }
    try {
      await _authService.signUp(email: state.email, password: state.password, displayName: state.displayName);
      emit(state.copyWith(status: ChangeStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ChangeStatus.error));
    }
  }

}
