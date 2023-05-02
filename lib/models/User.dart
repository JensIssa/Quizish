@Deprecated('Use FireAuth User instead')
class User {
  final String uid;
  final String? displayName;
  final String? email;

  User({required this.uid, this.displayName, this.email});

  @override
  String toString() => 'User { uid: $uid, displayName: $displayName, email: $email }';

  User.fromMap(Map<String, dynamic> data)
      : uid = data['uid'],
        displayName = data['displayName'],
        email = data['email'];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
    };
  }

}