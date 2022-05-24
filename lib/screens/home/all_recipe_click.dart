import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_app/components/my_bottom_nav_bar.dart';
import 'package:recipe_app/screens/home/components/body.dart';
import 'package:recipe_app/screens/home/components/category_list.dart';
import 'package:recipe_app/screens/home/components/indian_card.dart';
import 'package:recipe_app/screens/home/recipe_click_screen.dart';
import 'package:recipe_app/screens/login/login_screen.dart';
import 'package:recipe_app/screens/profile/prrofile_screen.dart';
import 'package:recipe_app/size_config.dart';
import 'package:recipe_app/models/RecipeBundel.dart';
import 'best_click_screen.dart';
import 'components/recipe_bundel_card.dart';
import 'food_court_click_screen.dart';

final allDisplayWidgets= [
  RecipeDisplay(),
  Best(),  
  FoodCourt(),  
];


class AllDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
              child: GridView.builder(
                itemCount: recipeBundles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      SizeConfig.orientation == Orientation.landscape ? 2 : 1,
                  mainAxisSpacing: 20,
                  crossAxisSpacing:
                      SizeConfig.orientation == Orientation.landscape
                          ? SizeConfig.defaultSize * 2
                          : 0,
                  childAspectRatio: 1.65,
                ),
                itemBuilder: (context, index) => RecipeBundelCard(
                  recipeBundle: recipeBundles[index],
                  press: () {
                    //routing
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => allDisplayWidgets[index]));
                  },
                ),
              ),
            ),
          );
  }
}