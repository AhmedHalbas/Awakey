import 'package:astronauthelper/authentication/signup_screen.dart';
import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/custom_widgets/custom_text_field.dart';
import 'package:astronauthelper/custom_widgets/logo_and_name.dart';
import 'package:astronauthelper/provider/modal_hud.dart';
import 'package:astronauthelper/screens/general_information.dart';
import 'package:astronauthelper/screens/home.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../functions.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final auth = Auth();

  String email, password;

  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
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
                height: height * 0.08,
              ),
              CustomTextField(
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
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: kSecondaryColor,
                    ),
                    child: Checkbox(
                      checkColor: kMainColor,
                      activeColor: kSecondaryColor,
                      value: isLoggedIn,
                      onChanged: (value) {
                        setState(() {
                          isLoggedIn = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Remember Me',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Builder(
                  builder: (context) => FlatButton(
                    onPressed: () async {
                      if (isLoggedIn) {
                        keepUserLoggedIn(isLoggedIn);
                      }
                      _validate(context);
                    },
                    color: kSecondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Login',
                        style: TextStyle(color: kMainColor),
                      ),
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
                    'Don\'t have an account? ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                    child: Text(
                      ' Sign Up',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, GeneralInformation.id,
                        arguments: 'WithAppBar');
                  },
                  color: kSecondaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      ' General Information',
                      style: TextStyle(
                          color: kMainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modalHud = Provider.of<ModalHud>(context, listen: false);
    modalHud.changeisLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();

      try {
        await auth.SignIn(email, password);
        modalHud.changeisLoading(false);
        Navigator.pushReplacementNamed(context, Home.id);
      } catch (e) {
        modalHud.changeisLoading(false);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
          ),
        );
      }
    }
    modalHud.changeisLoading(false);
  }
}
