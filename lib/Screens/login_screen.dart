import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                usernameInput(),
                passwordInput(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    newUserBtn(context),
                    loginBtn(context),
                    btnGoogle(context),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton loginBtn(BuildContext context) {
    return ElevatedButton(
        child: const Text('login'),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            setState(() {});
            return;
          }
          final email = _username.value.text;
          final password = _password.value.text;
          final user = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Placeholder(),
          ));
        });
  }

  ElevatedButton newUserBtn(BuildContext context) {
    return ElevatedButton(
        child: const Text('New User'),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            setState(() {});
            return;
          }
          final email = _username.value.text;
          final password = _password.value.text;
          final user = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
        });


  }

  TextFormField usernameInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _username,
      decoration: const InputDecoration(label: Text('Email')),
      validator: (value) =>
          (value == null || !value.contains('@')) ? 'Email required' : null,
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _password,
      decoration: const InputDecoration(label: Text('Password')),
      obscureText: true,
      validator: (value) => (value == null || value.length < 6)
          ? 'Password required (min 6 chars)'
          : null,
    );
  }

  Widget btnGoogle(BuildContext buildContext) {
    return Padding(
        padding: EdgeInsets.only(top: 128),
        child: Container(
          height: 60,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColorLight),
              shape: MaterialStateProperty.all
              <RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: Colors.red)),
              ),
            ),
            onPressed: () {
              loginWithGoogle().then((value) => {
                if (value != null)
                  {
                    Navigator.of(buildContext).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Placeholder(),
                    ))
                  }});
            },
            child: Text(
              'Log in with Google',
              style: TextStyle(
                  fontSize: 18, color:
              Theme.of(context).primaryColorDark),
            ),
          ),
        ));
  }
    loginWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(authCredential);

    return authResult;
  }
}

