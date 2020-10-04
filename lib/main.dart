import 'package:astronauthelper/authentication/member_signup_details_screen.dart';
import 'package:astronauthelper/authentication/signup_options_screen.dart';
import 'package:astronauthelper/authentication/signup_screen.dart';
import 'package:astronauthelper/provider/commander_mode.dart';
import 'package:astronauthelper/provider/modal_hud.dart';
import 'package:astronauthelper/screens/commander/commander_screen.dart';
import 'package:astronauthelper/screens/general_information.dart';
import 'package:astronauthelper/screens/home.dart';
import 'package:astronauthelper/screens/member/member_schedule.dart';
import 'package:astronauthelper/screens/member/member_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'authentication/login_screen.dart';
import 'authentication/commander_signup_details_screen.dart';
import 'constants.dart';

main() => runApp((myApp()));

class myApp extends StatefulWidget {
  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  bool isLoggedIn = false;
  FlutterLocalNotificationsPlugin fltrNotification;

  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings);

    _showNotification();
  }

  @override
  Widget build(BuildContext context) {
    _showNotification();
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          isLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModalHud>(
                create: (context) => ModalHud(),
              ),
              ChangeNotifierProvider<CommanderMode>(
                create: (context) => CommanderMode(),
              ),
            ],
            child: MaterialApp(
              theme: ThemeData.light().copyWith(
                primaryColor: Color(0xFF0066B2),
              ),
              initialRoute: isLoggedIn ? CommanderScreen.id : LoginScreen.id,
              routes: {
                LoginScreen.id: (context) => LoginScreen(),
                SignupScreen.id: (context) => SignupScreen(),
                SignUpOptionsScreen.id: (context) => SignUpOptionsScreen(),
                CommanderSignupDetailsScreen.id: (context) =>
                    CommanderSignupDetailsScreen(),
                MemberSignupDetailsScreen.id: (context) =>
                    MemberSignupDetailsScreen(),
                Home.id: (context) => Home(),
                CommanderScreen.id: (context) => CommanderScreen(),
                MemberScreen.id: (context) => MemberScreen(),
                MemberSchedule.id: (context) => MemberSchedule(),
                GeneralInformation.id: (context) => GeneralInformation(),
              },
            ),
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    var scheduledTime = DateTime.now().add(Duration(seconds: 5));
    fltrNotification.schedule(1, "Awakey", 'Your Wake Up Time In 5 Minutes',
        scheduledTime, generalNotificationDetails);
  }
}
