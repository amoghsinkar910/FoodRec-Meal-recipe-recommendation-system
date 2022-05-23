import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/size_config.dart';

import '../../login/login_screen.dart';
import 'info.dart';
import 'profile_menu_item.dart';

class Body extends StatelessWidget {
  String name;
  String email;
  Body({this.name, this.email});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Info(
            image: "assets/images/pic.png",
            name: name,
            email: email,
          ),
          SizedBox(height: SizeConfig.defaultSize * 2), //20
          ProfileMenuItem(
            iconSrc: "assets/icons/bookmark_fill.svg",
            title: "Saved Recipes",
            press: () {},
          ),
          ProfileMenuItem(
            iconSrc: "assets/icons/info.svg",
            title: "Logout",
            press: () async{
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=>LoginScreen())
                  );
            },
          ),
        ],
      ),
    );
  }
}
