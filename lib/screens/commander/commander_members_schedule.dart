import 'package:astronauthelper/services/auth.dart';
import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../../constants.dart';

class CommandersMembersSchedule extends StatefulWidget {
  int numberOfMembers;
  List<String> membersName = [];
  CommandersMembersSchedule(this.numberOfMembers, this.membersName);
  @override
  _CommandersMembersScheduleState createState() =>
      _CommandersMembersScheduleState();
}

class _CommandersMembersScheduleState extends State<CommandersMembersSchedule> {
  bool isEnabled = false, isShown = false;
  String buttonText = 'Edit Time';
  int tapBarIndex = 0, numberOfMembers;
  String uId, memberId;
  List<String> names = [];
  String memberName;
  final auth = Auth();
  final _fireStore = FireStore();
  List<String> newTimes = [];

  @override
  void initState() {
    super.initState();
    defaultData();
  }

  @override
  Widget build(BuildContext context) {
    names = widget.membersName;

    if (names.isEmpty) {
      return Center(
        child: Text(
          'No Members Yet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
    } else {
      return DefaultTabController(
        length: names.length,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Scaffold(
            appBar: TabBar(
              isScrollable: true,
              indicatorColor: kSecondaryColor,
              onTap: (value) {
                setState(() {
                  tapBarIndex = value;
                });
              },
              tabs: getFittedBoxes(),
            ),
            body: TabBarView(
              children: List<Widget>.generate(names.length, (int index) {
                print(names[0]);
                return memberView(names[index]);
              }),
            ),
          ),
        ),
      );
    }
  }

  memberView(name) {
    defaultData2(name);
    return SizedBox.expand(
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
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        StreamBuilder<DocumentSnapshot>(
            stream: _fireStore.getScheduleData(memberId),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.documentID == memberId) {
                  newTimes = [];
                  for (String activity in dailyActivities) {
                    newTimes.add(snapshot.data.data[activity]);
                  }
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
                  enabled: isEnabled,
                  onChanged: (val) {
                    newTimes[i] = val;
                    Firestore.instance
                        .collection(kUserCollection)
                        .document(memberId)
                        .updateData({dailyActivities[i]: val});

                    setState(() {});
                  },
                ),
                showEditIcon: isShown),
          ]),
        );
      }
    }
    return list;
  }

  defaultData2(name) {
    CollectionReference _documentRef =
        Firestore.instance.collection(kUserCollection);

    _documentRef.getDocuments().then((ds) {
      if (ds != null) {
        ds.documents.forEach((value) {
          if (value.data[kIsCommander] == false &&
              value.data[kMemberName] == name) {
            print('HERE');
            memberId = value.documentID;
          }
        });
      }
    });
  }

  defaultData() {
    CollectionReference _documentRef =
        Firestore.instance.collection(kUserCollection);

    _documentRef.getDocuments().then((ds) {
      if (ds != null) {
        ds.documents.forEach((value) {
          if (value.data[kIsCommander] == false &&
              value.data[kMemberName] == names[tapBarIndex]) {
            print('HERE');
            memberId = value.documentID;
            setState(() {});
          }
        });
      }
    });
    for (int i = 0; i < dailyActivities.length; i++) {
      Firestore.instance
          .collection(kUserCollection)
          .document(memberId)
          .updateData({dailyActivities[i]: times[i]});
    }
  }

  List<Text> getFittedBoxes() {
    List<Text> list = List<Text>();
    for (var i = 0; i < names.length; i++) {
      list.add(
        Text(
          names[i],
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      );
    }
    return list;
  }
}
