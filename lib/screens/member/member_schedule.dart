import 'package:astronauthelper/services/auth.dart';
import 'package:astronauthelper/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

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
    getUserID();
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
            StreamBuilder<DocumentSnapshot>(
                stream: _fireStore.getScheduleData(uId),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    newTimes = [];
                    for (String activity in dailyActivities) {
                      newTimes.add(snapshot.data.data[activity]);
                    }
                    return DataTable(columns: [
                      DataColumn(label: Text('Activity')),
                      DataColumn(label: Text('Time')),
                    ], rows: getDataRows(dailyActivities, newTimes));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })
          ]),
        ),
      ),
    );
  }

  List<DataRow> getDataRows(List<String> activities, List<String> newTimes) {
    if (newTimes[0] == null) {
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
                onChanged: (val) {
                  newTimes[i] = val;
                  Firestore.instance
                      .collection(kUserCollection)
                      .document(uId)
                      .updateData({dailyActivities[i]: val});
                },
              ),
            ),
          ]),
        );
      }
    }
    return list;
  }

  defaultData() {
    for (int i = 0; i < dailyActivities.length; i++) {
      Firestore.instance
          .collection(kUserCollection)
          .document(uId)
          .updateData({dailyActivities[i]: times[i]});
    }
  }

  Future<void> getUserID() async {
    uId = (await auth.getUser()).uid;
    setState(() {});
    // here you write the codes to input the data into firestore
  }
}
