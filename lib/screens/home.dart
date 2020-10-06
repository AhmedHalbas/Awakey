import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/screens/commander/commander_screen.dart';
import 'package:astronauthelper/screens/member/member_screen.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:astronauthelper/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static String id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = Auth();
  final _fireStore = FireStore();

  String uId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FirebaseUser>(
        future: auth.getUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            uId = snapshot.data.uid;
            return StreamBuilder<DocumentSnapshot>(
                stream: _fireStore.getScheduleData(uId),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return checkRole(snapshot);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget checkRole(snapshot) {
    if (snapshot.data[kIsCommander]) {
      return CommanderScreen();
    } else {
      return MemberScreen();
    }
  }
}
