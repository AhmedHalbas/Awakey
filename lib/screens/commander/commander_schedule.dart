import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:astronauthelper/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../functions.dart';

class CommanderSchedule extends StatefulWidget {
  static String id = 'CommanderSchedule';

  @override
  _CommanderScheduleState createState() => _CommanderScheduleState();
}

class _CommanderScheduleState extends State<CommanderSchedule> {
  bool isEnabled = false, isShown = false;
  String buttonText = 'Edit Time';
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    if (isEnabled) {
                      isEnabled = false;
                      isShown = false;
                      buttonText = 'Edit Time';
                    } else {
                      isEnabled = true;
                      isShown = true;
                      buttonText = 'Finish Edit';
                    }
                  });
                },
                color: Colors.black,
                child: Text(
                  buttonText,
                  style: TextStyle(color: kMainColor),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            FutureBuilder<FirebaseUser>(
              future: auth.getUser(),
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  uId = snapshot.data.uid;
                  print(uId);
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
                  enabled: isEnabled,
                  onFieldSubmitted: (val) {
                    newTimes[i] = val;
                    Firestore.instance
                        .collection(kUserCollection)
                        .document(uId)
                        .updateData({dailyActivities[i]: val});
                  },
                  onChanged: (val) {},
                ),
                showEditIcon: isShown),
          ]),
        );
      }
    }
    return list;
  }
}
