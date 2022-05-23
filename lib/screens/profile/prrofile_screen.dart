// import 'dart:js';
import 'package:flutter/material.dart';
import 'package:recipe_app/components/my_bottom_nav_bar.dart';
import 'package:recipe_app/constants.dart';
import 'package:recipe_app/screens/profile/components/body.dart';
import 'package:recipe_app/screens/profile/components/edit_profile.dart';
import 'package:recipe_app/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  String name;
  String email;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    User user = _auth.currentUser;
    if (user != null)  {
      name = user.displayName;
      email = user.email;
      print("########"+name);
      print("########"+email);
    }
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(name:name,email:email),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: BlueColor,
      leading: SizedBox(),
      // On Android it's false by default
      centerTitle: true,
      title: Text("Profile"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EditProfile())
            );
          },
          child: Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.defaultSize * 1.6, //16
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
