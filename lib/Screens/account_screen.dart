import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizish/FireServices/AuthService.dart';

class AccountDetails extends StatefulWidget {

  const AccountDetails({Key? key}) : super(key: key);

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final TextEditingController _displaynameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isObscurePassword = true;

  @override
  void dispose() {
    _displaynameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
        children: [
          SizedBox(height: 45),
          buildTextField('Displayname', false, _displaynameController),
          SizedBox(height: 45),
          buildTextField('E-mail', false, _emailController),
          SizedBox(height: 45),
          buildTextField('Password', true, _passwordController),
          SizedBox(height: 45),
         Align(
           alignment: Alignment.center,
           child: ElevatedButton(
             onPressed: () {
               updateAccountDetails();
             },
             child: Text(
               "Save",
               style: TextStyle(
                 fontSize: 22,
                 letterSpacing: 2,
                 color: Colors.white,
               ),
             ),
           ),
         )
        ],
        )
      ),
    );
  }
  Widget buildTextField(String labelText, bool isPasswordTextfield,
      TextEditingController textEditingController) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: textEditingController,
        style: TextStyle(
          fontSize: 20,
        ),
        obscureText: isPasswordTextfield ? isObscurePassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextfield
              ? IconButton(
            icon: Icon(
              isObscurePassword
                  ? Icons.remove_red_eye
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isObscurePassword = !isObscurePassword;
              });
            },
          )
              : null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  void updateAccountDetails() async {
    final String newDisplayname = _displaynameController.text.trim();
    final String newEmail = _emailController.text.trim();
    final String newPassword = _passwordController.text;

    bool isUpdated = false;

    if (newDisplayname.isEmpty && newEmail.isEmpty && newPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter at least one field to update.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      if (newDisplayname.isNotEmpty) {
        await _authService.updateDisplayName(newDisplayname);
        isUpdated = true;
      }
      if (newEmail.isNotEmpty) {
        await _authService.updateEmail(newEmail);
        isUpdated = true;
      }
      if (newPassword.isNotEmpty) {
        await _authService.updatePassword(newPassword);
        isUpdated = true;
      }
      if(isUpdated == true)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Account details updated successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      if(isUpdated == false)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while updating account details.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

