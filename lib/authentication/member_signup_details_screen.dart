import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/custom_widgets/custom_text_field.dart';
import 'package:astronauthelper/authentication/login_screen.dart';
import 'package:astronauthelper/models/member.dart';
import 'package:astronauthelper/provider/modal_hud.dart';
import 'package:astronauthelper/screens/member/member_screen.dart';
import 'package:astronauthelper/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astronauthelper/custom_widgets/logo_and_name.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:flutter/services.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class MemberSignupDetailsScreen extends StatefulWidget {
  static String id = 'MemberSignupDetailsScreen';

  @override
  _MemberSignupDetailsScreenState createState() =>
      _MemberSignupDetailsScreenState();
}

class _MemberSignupDetailsScreenState extends State<MemberSignupDetailsScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final auth = Auth();

  final _fireStore = FireStore();

  FirebaseUser firebaseUser;

  String uId;

  bool isCorrectMissionName = false;

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String fullName, role, missionName;
    int age;
    double weight, height;
    //checkMissionName(missionName);
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                LogoAndName(
                  title: 'Crew Member Details',
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                CustomTextField(
                  textInputType: TextInputType.text,
                  hint: 'Enter Your Full Name',
                  icon: Icons.perm_identity,
                  onSaved: (value) {
                    fullName = value;
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                CustomTextField(
                  textInputType: TextInputType.number,
                  hint: 'Enter Your Age',
                  icon: Icons.perm_identity,
                  onSaved: (value) {
                    age = int.parse(value);
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                CustomTextField(
                  textInputType: TextInputType.number,
                  hint: 'Enter Your Weight in kg',
                  icon: Icons.perm_identity,
                  onSaved: (value) {
                    weight = double.parse(value);
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                CustomTextField(
                  textInputType: TextInputType.number,
                  hint: 'Enter Your Height in cm',
                  icon: Icons.perm_identity,
                  onSaved: (value) {
                    height = double.parse(value);
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                CustomTextField(
                  textInputType: TextInputType.text,
                  hint: 'Enter Mission Name',
                  icon: Icons.perm_identity,
                  onSaved: (value) {
                    missionName = value;
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                CustomTextField(
                  textInputType: TextInputType.text,
                  hint: 'Enter Your Role',
                  icon: Icons.perm_identity,
                  onSaved: (value) {
                    role = value;
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 125),
                  child: Builder(
                    builder: (context) => FlatButton(
                      onPressed: () {
                        final modalHud =
                            Provider.of<ModalHud>(context, listen: false);

                        if (_globalKey.currentState.validate()) {
                          _globalKey.currentState.save();

                          checkMissionName(missionName);

                          if (isCorrectMissionName) {
                            modalHud.changeisLoading(true);
                            _fireStore.addMember(
                                Member(fullName, role, age, weight, height,
                                    false, missionName),
                                uId);

                            modalHud.changeisLoading(false);
                            Navigator.pushReplacementNamed(
                                context, MemberScreen.id);
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please Re-Check Mission Name'),
                              ),
                            );
                          }
                        }
                        modalHud.changeisLoading(false);
                      },
                      color: Colors.black,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getUserID() async {
    firebaseUser = await auth.getUser();
    uId = firebaseUser.uid;
    // here you write the codes to input the data into firestore
  }

  void checkMissionName(missionName) {
    CollectionReference _documentRef =
        Firestore.instance.collection(kUserCollection);

    _documentRef.getDocuments().then((ds) {
      if (ds != null) {
        ds.documents.forEach((value) {
          if (value.data[kMissionName] != null &&
              value.data[kMissionName] == missionName) {
            isCorrectMissionName = true;
            return;
          }
        });
      }
    });
  }
}
