import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoAndName extends StatelessWidget {
  String title;

  LogoAndName({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        children: <Widget>[
          Image.asset(
            'images/nasa_logo.png',
            width: 150,
            height: 150,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'SansitaSwashed',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
