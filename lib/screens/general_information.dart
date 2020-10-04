import 'package:astronauthelper/custom_widgets/alert_dialog.dart';
import 'package:astronauthelper/custom_widgets/information_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInformation extends StatefulWidget {
  static String id = 'GeneralInformation';
  @override
  _GeneralInformationState createState() => _GeneralInformationState();
}

class _GeneralInformationState extends State<GeneralInformation> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  InformationItem(
                    itemText: 'Sleep Shifts System',
                    Image: 'images/sleep.png',
                  ),
                  InformationItem(
                    itemText: 'Nutrition System',
                    Image: 'images/nutrition.png',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  InformationItem(
                    itemText: 'Exercise System',
                    Image: 'images/exercise.png',
                  ),
                  InformationItem(
                    itemText: 'Medication System',
                    Image: 'images/medication.png',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  InformationItem(
                    itemText: 'General Roles',
                    Image: 'images/roles.png',
                  ),
                  InformationItem(
                    itemText: 'Meed More Help? \n contact medical',
                    Image: 'images/help.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
