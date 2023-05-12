import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountDetails extends StatefulWidget {

  const AccountDetails({Key? key}) : super(key: key);

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  bool isObscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
        children: [
          SizedBox(height: 45),
          buildTextField('Fullname', false),
          SizedBox(height: 45),
          buildTextField('E-mail', false),
          SizedBox(height: 45),
          buildTextField('Password', true),
          SizedBox(height: 45),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
            child: ElevatedButton(onPressed: () {},
                child: const Text('Cancel', style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  color: Colors.white
                  ),
                ),
              ),
            ),
            SizedBox(width: 60),
            Expanded(
              flex: 1,
            child: ElevatedButton(
                onPressed: () {},
                child: Text("Save", style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  color: Colors.white
                )),
              ),
            )
          ],
          )
        ],
        )
      ),
    );
  }
  Widget buildTextField(String labelText, bool isPasswordTextfield) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
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
}
