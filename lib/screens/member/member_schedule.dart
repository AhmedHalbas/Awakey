import 'package:astronauthelper/services/auth.dart';
import 'package:astronauthelper/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../functions.dart';

class MemberSchedule extends StatefulWidget {
  static String id = 'MemberSchedule';

  @override
  _MemberScheduleState createState() => _MemberScheduleState();
}

class _MemberScheduleState extends State<MemberSchedule> {
  final auth = Auth();
  String uId;
  final _fireStore = FireStore();
  List<String> newTimes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
            FutureBuilder<FirebaseUser>(
              future: auth.getUser(),
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  uId = snapshot.data.uid;
                  return StreamBuilder<DocumentSnapshot>(
                      stream: _fireStore.getScheduleData(uId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data[dailyActivities[0]] != null) {
                            for (String activity in dailyActivities) {
                              newTimes.add(snapshot.data[activity]);
                            }
                          } else {
                            defaultData(uId);
                            newTimes.addAll(times);
                          }

                          return DataTable(columns: [
                            DataColumn(label: Text('Activity')),
                            DataColumn(label: Text('Time')),
                          ], rows: getDataRows(dailyActivities, newTimes));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  List<DataRow> getDataRows(List<String> activities, List<String> newTimes) {
    if (newTimes.isEmpty) {
      newTimes = times;
    }
    List<DataRow> list = List<DataRow>();
    for (var i = 0; i < activities.length; i++) {
      if (i == activities.length - 1) {
        list.add(
          DataRow(cells: [
            DataCell(Text(activities[i])),
            DataCell(
                TextFormField(
                  initialValue: newTimes[i],
                  enabled: false,
                  onFieldSubmitted: (val) {},
                ),
                showEditIcon: false),
          ]),
        );
      } else {
        list.add(
          DataRow(cells: [
            DataCell(Text(activities[i])),
            DataCell(
                TextFormField(
                  initialValue: newTimes[i],
                  enabled: false,
                  onFieldSubmitted: (val) {
                    newTimes[i] = val;
                    Firestore.instance
                        .collection(kUserCollection)
                        .document(uId)
                        .updateData({dailyActivities[i]: val});
                  },
                  onChanged: (val) {},
                ),
                showEditIcon: false),
          ]),
        );
      }
    }
    return list;
  }
}
