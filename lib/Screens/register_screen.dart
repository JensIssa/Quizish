import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizish/Screens/login_screen.dart';
import 'package:quizish/widgets/Appbar.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({Key? key}) : super(key: key);

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PurpleAppBar(title: 'Register your user',
        backgroundColor: Color(0xFF7885b2),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  usernameInput(),
                  emailInput(),
                  passwordInput(),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      registerBtn(context),
                    ],
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  ElevatedButton registerBtn(BuildContext context) {
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const loginScreen()
          ),
          );
        });
  }

  TextFormField usernameInput() {
    return TextFormField(
      controller: _username,
      decoration: const InputDecoration(label: Text('Username')),
      validator: (value) =>
      (value == null || value.length > 12 || value.length < 3) ? 'Invalid username (minimum 3 and maximum 12)' : null,
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _password,
      decoration: const InputDecoration(label: Text('Password')),
      obscureText: true,
      validator: (value) =>
      (value == null || value.length < 6)
          ? 'Password required (min 6 chars)'
          : null,
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      decoration: const InputDecoration(label: Text('Email')),
      validator: (value) =>
      (value == null || !value.contains('@')) ? 'Email required' : null,
    );
  }
}
