import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/custom_widgets/reusable_card.dart';
import 'package:flutter/material.dart';

class InformationItem extends StatelessWidget {
  final String itemText;
  final String Image;

  InformationItem({
    @required this.itemText,
    @required this.Image,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReusableCard(
        colour: kSecondaryColor,
        cardChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 80.0,
              width: 80.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Image),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  itemText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kMainColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
