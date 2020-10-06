import 'package:astronauthelper/authentication/commander_signup_details_screen.dart';
import 'package:astronauthelper/authentication/member_signup_details_screen.dart';
import 'package:astronauthelper/custom_widgets/logo_and_name.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SignUpOptionsScreen extends StatelessWidget {
  static String id = 'SignUpOptionsScreen';

  final auth = Auth();
  String uId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What\'s Your Role?'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            LogoAndName(
              title: 'Choose Your Role',
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ButtonTheme(
                minWidth: double.infinity,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, CommanderSignupDetailsScreen.id);
                  },
                  color: kSecondaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Ship leader',
                      style: TextStyle(color: kMainColor, fontSize: 20),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ButtonTheme(
                minWidth: double.infinity,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MemberSignupDetailsScreen.id);
                  },
                  color: kSecondaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Crew member',
                      style: TextStyle(color: kMainColor, fontSize: 20),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
