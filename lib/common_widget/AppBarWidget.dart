import 'package:flutter/material.dart';
import '../components/AppSignIn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

PreferredSizeWidget appBarWidget(BuildContext context) => AppBar(
      elevation: 0.0,
      centerTitle: true,
      title: Image.asset(
        "assets/images/ic_app_icon.png",
        width: 80,
        height: 40,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppSignIn()),
            );
          },
          icon: const Icon(FontAwesomeIcons.user),
          color: const Color(0xFF323232),
        ),
      ],
    );
