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
    return Container(
      child: ListView(
      children: [
        SizedBox(height: 30),
        buildTextField('Fullname', 'name', false),
        buildTextField('Email', 'name@gmail.com', false),
        buildTextField('Passowrd', '******', true),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(onPressed: () {},
              child: const Text('Cancel', style: TextStyle(
                fontSize: 15,
                letterSpacing: 2,
                color: Colors.black
              )),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            ),
          ),
          ElevatedButton(
              onPressed: () {},
              child: Text("Save", style: TextStyle(
                fontSize: 15,
                letterSpacing: 2,
                color: Colors.white
              )),
            ),
        ],
        )
      ],
      )
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextfield) {
      return Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: TextField(
          obscureText: isPasswordTextfield ? isObscurePassword : false,
          decoration: InputDecoration(
            suffixIcon: isPasswordTextfield ?
                IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                    onPressed: () {}
                  ): null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey
            )
          ),
        ),
      );
  }
}
