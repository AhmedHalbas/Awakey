import 'package:astronauthelper/authentication/login_screen.dart';
import 'package:astronauthelper/screens/member/member_schedule.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../general_information.dart';

class MemberScreen extends StatefulWidget {
  static String id = 'MemberScreen';
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  final auth = Auth();
  int navBarIndex = 0, numberOfMembers;

  List<String> membersNames;

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (navBarIndex) {
      case 0:
        child = MemberSchedule();
        break;

      case 1:
        child = GeneralInformation();
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Crew Member Dashboard'),
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
