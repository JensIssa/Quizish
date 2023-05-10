import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, submitting, success, error }

class RegisterState extends Equatable {
  final String username;
  final String email;
  final String password;
  final RegisterStatus status;

  const RegisterState({
    required this.username,
    required this.email,
    required this.password,
    required this.status
  });

  factory RegisterState.initial() {
    return const RegisterState(
      username: '',
      email: '',
      password: '',
      status: RegisterStatus.initial,
    );
  }

  RegisterState copyWith({
    String? username,
    String? email,
    String? password,
    RegisterStatus? status,
  }) {
    return RegisterState(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [username, email, password, status];
}