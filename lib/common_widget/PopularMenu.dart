// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/violins.dart';
import '../screens/drum.dart';
import '../screens/instrument.dart';
import '../screens/guitar.dart';

//ignore: must_be_immutable
class PopularMenu extends StatelessWidget {
  double width = 55.0, height = 55.0;
  double customFontSize = 13;
  String defaultFontFamily = 'Roboto-Light.ttf';

  PopularMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => guitar(),
                      ),
                    );
                  },
                  shape: CircleBorder(),
                  child: Icon(
                    FontAwesomeIcons.guitar,
                    color: Color(0xFFAB436B),
                  ),
                ),
              ),
              Text(
                "guitar",
                style: TextStyle(
                    color: Color(0xFF969696),
                    fontFamily: 'Roboto-Light.ttf',
                    fontSize: customFontSize),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => instrument(),
                      ),
                    );
                  },
                  shape: CircleBorder(),
                  child: Icon(
                    FontAwesomeIcons.music,
                    color: Color(0xFFC1A17C),
                  ),
                ),
              ),
              Text(
                "instruments",
                style: TextStyle(
                    color: Color(0xFF969696),
                    fontFamily: defaultFontFamily,
                    fontSize: customFontSize),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => drumProduct(),
                      ),
                    );
                  },
                  shape: CircleBorder(),
                  child: Icon(
                    FontAwesomeIcons.drum,
                    color: Color(0xFF5EB699),
                  ),
                ),
              ),
              Text(
                "drum",
                style: TextStyle(
                    color: Color(0xFF969696),
                    fontFamily: defaultFontFamily,
                    fontSize: customFontSize),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => violinsProducts(),
                      ),
                    );
                  },
                  shape: CircleBorder(),
                  child: Icon(
                    FontAwesomeIcons.guitar,
                    color: Color(0xFF4D9DA7),
                  ),
                ),
              ),
              Text(
                "violin",
                style: TextStyle(
                    color: Color(0xFF969696),
                    fontFamily: defaultFontFamily,
                    fontSize: customFontSize),
              ),
            ],
          )
        ],
      ),
    );
  }
}
