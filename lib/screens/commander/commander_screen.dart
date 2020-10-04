import 'package:astronauthelper/authentication/login_screen.dart';
import 'package:astronauthelper/screens/commander/commander_members_schedule.dart';
import 'package:astronauthelper/screens/general_information.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import 'commander_schedule.dart';

class CommanderScreen extends StatefulWidget {
  static String id = 'CommanderScreen';
  @override
  _CommanderScreenState createState() => _CommanderScreenState();
}

class _CommanderScreenState extends State<CommanderScreen> {
  final auth = Auth();
  int navBarIndex = 0, numberOfMembers;
  String uId;
  List<String> membersNames;

  @override
  void initState() {
    getUserID();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getNumberOfMembers(uId);
    getMembersNames();
    Widget child;
    switch (navBarIndex) {
      case 0:
        child = CommanderSchedule();
        break;
      case 1:
        child = CommandersMembersSchedule(numberOfMembers, membersNames);
        break;
      case 2:
        child = GeneralInformation();
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Ship Leader Dashboard'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Center(
                      child: GestureDetector(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.clear();
                          await auth.signOut();
                          Navigator.popAndPushNamed(context, LoginScreen.id);
                        },
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: Center(
                      child: GestureDetector(
                        child: Text(
                          'Contact us',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          _sendMail();
                        },
                      ),
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) async {
            setState(() {
              navBarIndex = value;
            });
          },
          currentIndex: navBarIndex,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: kUnActiveColor,
          fixedColor: kMainColor,
          items: [
            BottomNavigationBarItem(
              title: Text(
                'Home',
                style: TextStyle(
                  color: kUnActiveColor,
                ),
              ),
              icon: Icon(
                Icons.home,
                color: kUnActiveColor,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(
                'Members',
                style: TextStyle(
                  color: kUnActiveColor,
                ),
              ),
              icon: Icon(
                Icons.person,
                color: kUnActiveColor,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(
                'General Info',
                style: TextStyle(
                  color: kUnActiveColor,
                ),
              ),
              icon: Icon(
                Icons.info,
                color: kUnActiveColor,
              ),
            ),
          ],
        ),
        body: SizedBox.expand(child: child));
  }

  Future<void> getNumberOfMembers(uid) async {
    DocumentSnapshot commanderData = await Firestore.instance
        .collection(kUserCollection)
        .document(uid)
        .get();

    numberOfMembers = commanderData.data[kNumberOfMembers];
  }

  Future<void> getUserID() async {
    uId = (await auth.getUser()).uid;
    setState(() {});
    // here you write the codes to input the data into firestore
  }

  void getMembersNames() {
    CollectionReference _documentRef =
        Firestore.instance.collection(kUserCollection);

    _documentRef.getDocuments().then((ds) {
      if (ds != null) {
        membersNames = [];
        ds.documents.forEach((value) {
          if (value.data[kMemberName] != null)
            membersNames.add(value.data[kMemberName]);
        });
      }
    });
  }

  _sendMail() async {
    // Android and iOS
    const uri = 'mailto:admin@awakey.io';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
