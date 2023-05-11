import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/Screens/homescreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizish/Screens/register_screen.dart';
import 'package:quizish/bloc/login_bloc/LoginCubit.dart';
import 'package:quizish/bloc/login_bloc/LoginState.dart';
import 'package:quizish/widgets/Appbar.dart';


class loginScreen extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  loginScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizish Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocProvider(
              create: (_) =>
                  LoginCubit(
                      context.read<AuthService>()
                  ),
              child: LoginForm()
          ),
        ),
      ),
    );
  }
}

   class LoginForm extends StatelessWidget {
     LoginForm({Key? key}) : super(key: key);
     final _formKey = GlobalKey<FormState>();

     @override
     Widget build(BuildContext context) {
       return BlocListener<LoginCubit, LoginState>(
         listener: (context, state) {
           if (state.status == LoginStatus.error) {
             ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text("Login Failed - Please provide correct E-mail and password"),
                   backgroundColor: Colors.red,
                 )
             );
           }
         },
         child: Form(
           key: _formKey,
           child: Column(
             children: [
               SizedBox(height: 15),
               emailInput(),
               SizedBox(height: 30),
               passwordInput(),
               const SizedBox(height: 32),
               loginBtn(),
               SizedBox(height: 15),
               newUserBtn(),
               btnGoogle(context),
             ],
           ),
         ),
       );
     }
   }

  class loginBtn extends StatelessWidget  {
    @override
    Widget build(BuildContext context){
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, status){
      return ElevatedButton(
          style: ButtonStyle(
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
            context.read<LoginCubit>().logInWithCredentials();;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
          });
    });
  }
}

class newUserBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          fixedSize: MaterialStatePropertyAll(Size.fromWidth(150)),
      ),
      child: const Text(
        'Sign up here',
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () => Navigator.of(context).push<void>(registerScreen.route()),
    );
  }
}


class emailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (email) {
              context.read<LoginCubit>().emailChanged(email);
            },
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                label: Text(
                  'Email',
                  style: TextStyle(fontSize: 20),
                )),
            validator: (value) => (value == null || !value.contains('@'))
                ? 'Email required'
                : null,
          );
        });
  }
}

class passwordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextFormField(
            onChanged: (password) {
              context.read<LoginCubit>().passwordChanged(password);
            },
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                label: Text(
                  'Password',
                  style: TextStyle(fontSize: 20),
                )),
            obscureText: true,
            validator: (value) =>
            (value == null || value.length < 6)
                ? 'Password required (min 6 chars)'
                : null,
          );
        }
    );
  }
}

  Widget btnGoogle(BuildContext buildContext) {
    return Padding(
        padding: EdgeInsets.only(top: 128),
        child: Container(
          height: 60,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(buildContext).primaryColorLight),
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
                  fontSize: 18, color: Theme.of(buildContext).primaryColorDark),
            ),
          ),
        ));
  }

  loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final _auth = FirebaseAuth.instance;
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

