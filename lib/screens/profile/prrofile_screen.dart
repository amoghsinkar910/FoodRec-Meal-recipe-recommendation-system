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
  String myemail;
  @override
  Widget build(BuildContext context) {
    print("Start of prrofile_screen.dart");
    SizeConfig().init(context);
    User user = _auth.currentUser;
    fetch();
    //user.reload();
    //print(user);
    // if (user != null)  {
    //   user.displayName==null?name="Amogh":name=user.displayName;
    //   email = user.email;
    //   print("########"+name);
    //   print("########"+email);
    // }
    print("End of prrofile_screen.dart");
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

  void fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser!=null)
    {
      await FirebaseFirestore.instance
      .collection('users')
      .doc(firebaseUser.uid)
      .get()
      .then((ds) {
        print("FETCHED################");

        print(ds.data());
        print(ds.data());
        })
      .catchError((e){
        print(e);
      });
    }
  }
}
