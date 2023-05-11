
import 'package:equatable/equatable.dart';
import '../models/User.dart';

abstract class AppEvent extends Equatable {

const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogOutRequested extends AppEvent {}

class AppUserChanged extends AppEvent{
  final User user;

  const AppUserChanged(this.user);

  @override
  List<Object> get props => [user];
}