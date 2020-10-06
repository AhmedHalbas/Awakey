import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

void keepUserLoggedIn(isLoggedIn) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  preferences.setBool(kKeepMeLoggedIn, isLoggedIn);
}

defaultData(id) {
  for (int i = 0; i < dailyActivities.length; i++) {
    Firestore.instance
        .collection(kUserCollection)
        .document(id)
        .updateData({dailyActivities[i]: times[i]});
  }
}
