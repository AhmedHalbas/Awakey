import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/custom_widgets/custom_text_field.dart';
import 'package:astronauthelper/custom_widgets/logo_and_name.dart';
import 'package:astronauthelper/models/commander.dart';
import 'package:astronauthelper/provider/modal_hud.dart';
import 'package:astronauthelper/screens/commander/commander_screen.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:astronauthelper/services/fire_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommanderSignupDetailsScreen extends StatefulWidget {
  static String id = 'CommanderSignupDetailsScreen';

  @override
  _CommanderSignupDetailsScreenState createState() =>
      _CommanderSignupDetailsScreenState();
}

class _CommanderSignupDetailsScreenState
    extends State<CommanderSignupDetailsScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  var textController = TextEditingController();
  final focusNode = FocusNode();

  final auth = Auth();

  final _fireStore = FireStore();
  FirebaseUser firebaseUser;
  String uId;

  @override
  void initState() {
    super.initState();
    getId();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String fullName, role, missionName, departureDateandTime, initialValue;
    int age, numberOfMembers;
    double weight, height;

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
                  title: 'Ship Leader Details',
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
                  hint: 'Enter Your Role',
                  icon: Icons.perm_identity,
                  onSaved: (value) {
                    role = value;
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                CustomTextField(
                  textInputType: TextInputType.number,
                  hint: 'Enter Number of Members',
                  icon: Icons.perm_identity,
                  onSaved: (value) {
                    numberOfMembers = int.parse(value);
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
                  controller: textController,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());

                    //SystemChannels.textInput.invokeMethod('TextInput.hide');
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 10, 1),
                        maxTime: DateTime(2025, 12, 31), onConfirm: (date) {
                      setState(() {
                        textController.text = date.toString();
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  hint: 'Enter Departure Date and Time',
                  icon: Icons.date_range,
                  onSaved: (value) {
                    departureDateandTime = value;
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 125),
                  child: Builder(
                    builder: (context) => FlatButton(
                      onPressed: () async {
                        final modalHud =
                            Provider.of<ModalHud>(context, listen: false);

                        if (_globalKey.currentState.validate()) {
                          _globalKey.currentState.save();
                          if (numberOfMembers <= 2) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Minimum Number of Members is 3'),
                              ),
                            );
                          } else {
                            print(uId);
                            modalHud.changeisLoading(true);
                            _fireStore.addCommander(
                                Commander(
                                    fullName,
                                    role,
                                    missionName,
                                    departureDateandTime,
                                    age,
                                    numberOfMembers,
                                    weight,
                                    height,
                                    true),
                                uId);
                            modalHud.changeisLoading(false);
                            Navigator.pushReplacementNamed(
                                context, CommanderScreen.id);
                          }
                        }
                        modalHud.changeisLoading(false);
                      },
                      color: Colors.black,
                      child: Text(
                        'Finish',
                        style: TextStyle(color: kMainColor),
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

  getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uId = prefs.getString(kUserId);
  }
}
