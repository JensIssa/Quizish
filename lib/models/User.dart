import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? uid;
  final String? email;
  final String? displayName;

  const User({required this.uid,  this.email, this.displayName});

  static const empty = User(uid: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  Map<dynamic, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'display': displayName,
    };
  }

  @override
  List<Object?> get props => [uid, email, displayName];
}