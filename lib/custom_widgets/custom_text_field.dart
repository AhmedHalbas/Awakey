import 'package:astronauthelper/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onSaved;
  final Function onChanged;
  final String initialValue;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function onTap;

  CustomTextField(
      {this.onSaved,
        this.onChanged,
      @required this.hint,
      @required this.icon,
      this.textInputType,
      this.onTap,
      this.controller,
      this.initialValue});

  String _errorMessages() {
    switch (hint) {
      case 'Enter Your Full Name':
        return 'Fill Name';
      case 'Enter Your Email':
        return 'Fill Email';
      case 'Enter Your Password':
        return 'Fill Password';
      case 'Enter Your Age':
        return 'Fill Age';
      case 'Enter Your Weight in kg':
        return 'Fill Weight';
      case 'Enter Your Height in cm':
        return 'Fill Height';
      case 'Enter Your Role':
        return 'Fill Role';
      case 'Enter Number of Members':
        return 'Fill Number of Members (Min 3)';
      case 'Enter Departure Date':
        return 'Fill Departure Date';
      case 'Enter Departure Time':
        return 'Fill Departure Time';
      case 'Enter Mission Name':
        return 'Fill Mission Name';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        style: TextStyle(
          color: kMainColor,
        ),
        initialValue: initialValue,
        controller: controller,
        keyboardType: textInputType,
        onTap: onTap,
        // ignore: missing_return
        validator: (value) {
          if (value.isEmpty) {
            return _errorMessages();
          }
        },
        obscureText: hint == 'Enter Your Password' ? true : false,
        onChanged: onChanged,
        onSaved: onSaved,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: kMainColor),
          prefixIcon: Icon(
            icon,
            color: kMainColor,
          ),
          filled: true,
          fillColor: kSecondaryColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
