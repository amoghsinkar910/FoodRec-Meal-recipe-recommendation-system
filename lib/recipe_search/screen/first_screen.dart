import 'package:flutter/material.dart';
import 'package:recipe_app/components/my_bottom_nav_bar.dart';
import 'package:recipe_app/constants.dart';
import 'package:recipe_app/recipe_search/home.dart';
import 'package:recipe_app/size_config.dart';

class SearchScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Home(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}