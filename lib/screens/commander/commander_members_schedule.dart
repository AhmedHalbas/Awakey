import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/services/auth.dart';
import 'package:astronauthelper/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../functions.dart';

class CommandersMembersSchedule extends StatefulWidget {
  static String id = 'CommandersMembersSchedule';
  List<String> membersName = [];

  CommandersMembersSchedule(this.membersName);

  @override
  _CommandersMembersScheduleState createState() =>
      _CommandersMembersScheduleState();
}

class _CommandersMembersScheduleState extends State<CommandersMembersSchedule> {
  bool isEnabled = false, isShown = false;
  String buttonText = 'Edit Time';
  int tapBarIndex = 0, numberOfMembers;
  String uId, memberId;
  String memberName;
  final auth = Auth();
  final _fireStore = FireStore();
  List<String> newTimes = [];

  @override
  Widget build(BuildContext context) {
    if (widget.membersName.isEmpty) {
      return Center(
        child: Text(
          'No Members Yet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
    } else {
      return DefaultTabController(
        length: widget.membersName.length,
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
              children:
              List<Widget>.generate(widget.membersName.length, (int index) {
                return memberView();
              }),
            ),
          ),
        ),
      );
    }
  }

  memberView() {
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
              style: TextStyle(color: kMainColor),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _fireStore.getMemberId(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                DocumentSnapshot document = snapshot.data.documents[i];
                if (document[kIsCommander] == false &&
                    document[kMemberName] == widget.membersName[tapBarIndex]) {
                  memberId = document.documentID;
                }
              }
              return StreamBuilder<DocumentSnapshot>(
                  stream: _fireStore.getScheduleData(memberId),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      newTimes.clear();
                      print('HERE:${memberId}');
                      if (snapshot.data[dailyActivities[0]] != null) {
                        for (String activity in dailyActivities) {
                          newTimes.add(snapshot.data[activity]);
                        }
                      } else {
                        defaultData(memberId);
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
                        .document(memberId)
                        .updateData({dailyActivities[i]: val});
                    setState(() {});
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

  List<Text> getFittedBoxes() {
    List<Text> list = List<Text>();
    for (var i = 0; i < widget.membersName.length; i++) {
      list.add(
        Text(
          widget.membersName[i],
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
