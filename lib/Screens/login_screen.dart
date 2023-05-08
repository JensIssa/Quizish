import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizish/FireServices/UserService.dart';
import 'package:quizish/Screens/homescreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizish/Screens/register_screen.dart';
import 'package:quizish/widgets/Appbar.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PurpleAppBar(
        title: 'Quizish Login',
        backgroundColor: Color(0xFF7885b2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 15),
                emailInput(),
                SizedBox(height: 30),
                passwordInput(),
                const SizedBox(height: 32),
                loginBtn(context),
                SizedBox(height: 15),
                newUserBtn(context),
                btnGoogle(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton loginBtn(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Color(0xFF7885b2)),
            fixedSize: MaterialStatePropertyAll(Size.fromWidth(150))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Login',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward),
          ],
        ),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            setState(() {});
            return;
          }
          final email = _email.value.text;
          final password = _password.value.text;
          userService.signIn(email, password);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const homeScreen(),
          ));
        });
  }

  ElevatedButton newUserBtn(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          fixedSize: MaterialStatePropertyAll(Size.fromWidth(150)),
        backgroundColor: MaterialStateColor.resolveWith((states) =>
            Color(0xFF7885b2))
      ),
        child: const Text('Sign up here', style: TextStyle(fontSize: 20),),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const registerScreen(),
          ));
        });
  }

  TextFormField emailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.email),
          label: Text(
            'Email',
            style: TextStyle(fontSize: 20),
          )),
      validator: (value) =>
          (value == null || !value.contains('@')) ? 'Email required' : null,
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _password,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock),
          label: Text(
            'Password',
            style: TextStyle(fontSize: 20),
          )),
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
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: Colors.red)),
              ),
            ),
            onPressed: () {
              loginWithGoogle().then((value) => {
                    if (value != null)
                      {
                        Navigator.of(buildContext)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const Placeholder(),
                        ))
                      }
                  });
            },
            child: Text(
              'Log in with Google',
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColorDark),
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
