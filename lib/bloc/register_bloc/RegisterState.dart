import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, submitting, success, error }

class RegisterState extends Equatable {
  final String email;
  final String password;
  final String displayName;
  final RegisterStatus status;

  const RegisterState({
    required this.email,
    required this.password,
    required this.displayName,
    required this.status
  });

  factory RegisterState.initial() {
    return const RegisterState(
      email: '',
      password: '',
      displayName: '',
      status: RegisterStatus.initial,
    );
  }

  RegisterState copyWith({
    String? email,
    String? password,
    String? displayName,
    RegisterStatus? status,
  }) {
    return RegisterState(
        email: email ?? this.email,
        password: password ?? this.password,
        displayName: displayName ?? this.displayName,
        status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [ email, password, status, displayName];
}