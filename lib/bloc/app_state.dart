
import 'package:equatable/equatable.dart';

import '../models/User.dart';

enum AppStatus { authenticated, unauthenticated}

class AppState extends Equatable {

  final AppStatus status;
  final User user;


  const AppState._({
    required this.status,
    this.user = User.empty,
});

  /**
   * This method sets the app state to authenticated with the user
   */
  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  /**
   * This method sets the app state to unauthenticated
   */
  const AppState.unauthenticated()
      : this._(
    status: AppStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}