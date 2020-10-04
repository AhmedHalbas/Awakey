import 'package:astronauthelper/authentication/commander_signup_details_screen.dart';
import 'package:astronauthelper/authentication/member_signup_details_screen.dart';
import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/custom_widgets/logo_and_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpOptionsScreen extends StatelessWidget {
  static String id = 'SignUpOptionsScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kMainColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LogoAndName(
                title: ' ',
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, CommanderSignupDetailsScreen.id);
                },
                color: Color(0xFF0066B2),
                child: Text(
                  'Register as Ship leader',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, MemberSignupDetailsScreen.id);
                },
                color: Color(0xFF0066B2),
                child: Text(
                  'Register as Crew member',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
