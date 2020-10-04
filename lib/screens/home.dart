import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/screens/commander/commander_screen.dart';
import 'package:astronauthelper/screens/member/member_screen.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  static String id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = Auth();

  String uId;

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection(kUserCollection)
            .document(uId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return checkRole(snapshot);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  StatefulWidget checkRole(snapshot) {
    if (snapshot.data[kIsCommander]) {
      return CommanderScreen();
    } else {
      return MemberScreen();
    }
  }

  Future<void> getUserID() async {
    uId = (await auth.getUser()).uid;
    setState(() {});
    // here you write the codes to input the data into firestore
  }
}
