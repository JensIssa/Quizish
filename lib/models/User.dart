import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? uid;
  final String? email;
  final String? displayName;

  const User({required this.uid,  this.email, this.displayName});

  static const empty = User(uid: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  User copyWith({String? email, String? displayName}) {
    return User(
      uid: this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uid, email, displayName];
}

