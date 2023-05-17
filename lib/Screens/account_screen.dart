import 'package:flutter/material.dart';
import 'package:quizish/FireServices/AuthService.dart';

class AccountDetails extends StatelessWidget {
  final TextEditingController _displaynameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  AccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 45),
            buildTextField('Display-name', false, _displaynameController),
            const SizedBox(height: 45),
            buildTextField('E-mail', false, _emailController),
            const SizedBox(height: 45),
            buildTextField('Password', true, _passwordController),
            const SizedBox(height: 45),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  updateAccountDetails(context,
                    _displaynameController,
                    _emailController,
                    _passwordController,
                    _authService,
                  );
                },
                child: const Text(
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
    );
  }

  Widget buildTextField(
      String labelText,
      bool isPasswordTextfield,
      TextEditingController textEditingController
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: textEditingController,
        style: const TextStyle(
          fontSize: 20,
        ),
        obscureText: isPasswordTextfield,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF7885b2)),
          )
        ),
      ),
    );
  }

  void updateAccountDetails(BuildContext context,
      TextEditingController displayNameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      AuthService authService) async {
    final String newDisplayName = displayNameController.text.trim();
    final String newEmail = emailController.text.trim();
    final String newPassword = passwordController.text;

    bool isUpdated = false;

    if (newDisplayName.isEmpty && newEmail.isEmpty && newPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter at least one field to update.'),
            actions: [
              TextButton(
                child: const Text('OK'),
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
      if (newDisplayName.isNotEmpty) {
        await authService.updateDisplayName(newDisplayName);
        isUpdated = true;
      }
      if (newEmail.isNotEmpty) {
        await authService.updateEmail(newEmail);
        isUpdated = true;
      }
      if (newPassword.isNotEmpty) {
        await authService.updatePassword(newPassword);
        isUpdated = true;
      }
      if (isUpdated)
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred while updating account details.'),
            actions: [
              TextButton(
                child: const Text('OK'),
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
