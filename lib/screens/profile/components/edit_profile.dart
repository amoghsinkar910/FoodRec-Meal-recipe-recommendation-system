import 'package:flutter/material.dart';
import 'package:recipe_app/components/my_bottom_nav_bar.dart';
import 'package:recipe_app/constants.dart';
import 'package:recipe_app/screens/profile/components/body.dart';
import 'package:recipe_app/screens/profile/components/edit_firebase.dart';
import 'package:recipe_app/size_config.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: EditFirebase(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: BlueColor,
      elevation: 0,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      centerTitle: true,
      title: Text("Update Profile"),
    );
  }
}
