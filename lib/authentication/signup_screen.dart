import 'package:astronauthelper/authentication/signup_options_screen.dart';
import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/custom_widgets/custom_text_field.dart';
import 'package:astronauthelper/custom_widgets/logo_and_name.dart';
import 'package:astronauthelper/provider/modal_hud.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  static String id = 'SignupScreen';
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final auth = Auth();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String email, password;

    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              LogoAndName(
                title: 'Awakey',
              ),
              SizedBox(
                height: height * 0.03,
              ),
              CustomTextField(
                textInputType: TextInputType.emailAddress,
                hint: 'Enter Your Email',
                icon: Icons.email,
                onSaved: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: height * 0.03,
              ),
              CustomTextField(
                hint: 'Enter Your Password',
                icon: Icons.lock,
                onSaved: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 125),
                child: Builder(
                  builder: (context) => FlatButton(
                    onPressed: () async {
                      final modalHud =
                          Provider.of<ModalHud>(context, listen: false);
                      modalHud.changeisLoading(true);
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        try {
                          await auth.SignUp(email.trim(), password.trim());
                          modalHud.changeisLoading(false);
                          Navigator.pushNamed(context, SignUpOptionsScreen.id);
                        } on PlatformException catch (e) {
                          modalHud.changeisLoading(false);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.message),
                            ),
                          );
                        }
                      }
                      modalHud.changeisLoading(false);
                    },
                    color: Color(0xFF0066B2),
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Do have an account? ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    child: Text(
                      ' Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
