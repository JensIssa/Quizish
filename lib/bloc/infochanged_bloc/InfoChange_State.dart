import 'package:equatable/equatable.dart';

enum ChangeStatus { initial, submitting, success, error }

class ChangeState extends Equatable {
  final String email;
  final String password;
  final String displayName;
  final ChangeStatus status;

  const ChangeState({
    required this.email,
    required this.password,
    required this.displayName,
    required this.status
  });

  factory ChangeState.initial() {
    return const ChangeState(
      email: '',
      password: '',
      displayName: '',
      status: ChangeStatus.initial,
    );
  }

  ChangeState copyWith({
    String? email,
    String? password,
    String? displayName,
    ChangeStatus? status,
  }) {
    return ChangeState(
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
    );
  }
  @override
  List<Object> get props => [ email, password, status, displayName];
}