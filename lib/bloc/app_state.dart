import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:quizish/FireServices/UserService.dart';

import '../models/User.dart';

enum AppStatus { authenticated, unauthenticated}

class AppState extends Equatable {

  final AppStatus status;
  final User user;


  const AppState._({
    required this.status,
    this.user = User.empty,
});

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

const AppState.unauthenticated()
      : this._(
    status: AppStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}