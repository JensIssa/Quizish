import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizish/Screens/login_screen.dart';
import 'package:quizish/Widgets/quiz_button.dart';
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
                  SizedBox(height: 15),
                  usernameInput(),
                  SizedBox(height: 30),
                  emailInput(),
                  SizedBox(height: 30),
                  passwordInput(),
                  const SizedBox(height: 32),
                  registerBtn(context),
                  backBtn(context)
                ],
              ),
            )
        ),
      ),
    );
  }

  ElevatedButton backBtn(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const loginScreen()),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) =>
            Color(0xFF7885b2)),
      ),
      label: Text('Back', style: TextStyle(fontSize: 20),
      ),
      icon: Icon(Icons.arrow_back),
    );
  }

  ElevatedButton registerBtn(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) =>
              Color(0xFF7885b2)),
        ),
        child: const Text('New User', style: TextStyle(fontSize: 20)),
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
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        label: Text('Username',
          style: TextStyle(fontSize: 20),
        ),
      ),
      validator: (value) =>
      (value == null || value.length > 12 || value.length < 3)
          ? 'Invalid username (minimum 3 and maximum 12)'
          : null,
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _password,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.lock),
        label: Text('Password',
          style: TextStyle(fontSize: 20),
        ),
      ),
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
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email),
        label: Text('Email',
          style: TextStyle(fontSize: 20),
        ),
      ),
      validator: (value) =>
      (value == null || !value.contains('@')) ? 'Email required' : null,
    );
  }
}
