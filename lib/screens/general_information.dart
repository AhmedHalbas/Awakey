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
    final arguments = ModalRoute
        .of(context)
        .settings
        .arguments;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: arguments != null
          ? AppBar(
        title: Text('General Information'),
      )
          : null,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  InformationItem(
                    itemText: 'Sleep Shifts System',
                    Image: 'images/general_information/sleep.png',
                  ),
                  InformationItem(
                    itemText: 'Nutrition System',
                    Image: 'images/general_information/nutrition.png',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  InformationItem(
                    itemText: 'Exercise System',
                    Image: 'images/general_information/exercise.png',
                  ),
                  InformationItem(
                    itemText: 'Medication System',
                    Image: 'images/general_information/medication.png',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  InformationItem(
                    itemText: 'General Roles',
                    Image: 'images/general_information/roles.png',
                  ),
                  InformationItem(
                    itemText: 'Meed More Help? \n contact medical',
                    Image: 'images/general_information/help.png',
                    onPress: () {},
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
