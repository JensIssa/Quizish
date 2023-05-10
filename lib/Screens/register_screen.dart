import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/Screens/login_screen.dart';
import 'package:quizish/widgets/Appbar.dart';
import '../bloc/register_bloc/RegisterCubit.dart';
import '../bloc/register_bloc/RegisterState.dart';


class registerScreen extends StatelessWidget{
   registerScreen({Key? key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) =>  registerScreen());
  }

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PurpleAppBar(
        title: 'Register your user',
        backgroundColor: Color(0xFF7885b2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocProvider<RegisterCubit>(
            create: (_) => RegisterCubit(context.read<AuthService>()),
            child: RegisterForm(context),
          ),
        ),
      ),
    );
  }

  BlocListener RegisterForm(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
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
        ));
  }

  ElevatedButton backBtn(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const loginScreen()),
        );
      },
      style: ButtonStyle(
        fixedSize: MaterialStatePropertyAll(Size.fromWidth(150)),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Color(0xFF7885b2)),
      ),
      label: Text(
        'Back',
        style: TextStyle(fontSize: 20),
      ),
      icon: Icon(Icons.arrow_back),
    );
  }

  BlocBuilder registerBtn(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status == RegisterStatus.submitting ?
              const CircularProgressIndicator():
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size.fromWidth(150)),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Color(0xFF7885b2)),
              ),
              child: const Text('New User', style: TextStyle(fontSize: 20)),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                context.read<RegisterCubit>().registerFormSubmitted();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const loginScreen()),
                );
              });
        });
  }

  TextFormField usernameInput() {
    return TextFormField(
      controller: _username,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        label: Text(
          'Username',
          style: TextStyle(fontSize: 20),
        ),
      ),
      validator: (value) =>
          (value == null || value.length > 12 || value.length < 3)
              ? 'Invalid username (minimum 3 and maximum 12)'
              : null,
    );
  }

  BlocBuilder passwordInput() {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            controller: _password,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              label: Text(
                'Password',
                style: TextStyle(fontSize: 20),
              ),
            ),
            obscureText: true,
            validator: (value) => (value == null || value.length < 6)
                ? 'Password required (min 6 chars)'
                : null,
          );
        });
  }

  BlocBuilder emailInput() {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _email,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              label: Text(
                'E-mail',
                style: TextStyle(fontSize: 20),
              ),
            ),
            validator: (value) => (value == null || !value.contains('@'))
                ? 'Email required'
                : null,
          );
        });
  }
}
