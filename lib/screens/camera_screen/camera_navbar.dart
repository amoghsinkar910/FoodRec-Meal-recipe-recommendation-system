import 'package:flutter/material.dart';
import 'package:recipe_app/components/my_bottom_nav_bar.dart';
import 'package:recipe_app/constants.dart';
import 'package:recipe_app/screens/camera_screen/pick_image_screen.dart';
import 'package:recipe_app/size_config.dart';

class CameraScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ImagePickPage(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}