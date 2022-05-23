import 'package:flutter/material.dart';
import 'package:recipe_app/models/RecipeBundel.dart';
import 'package:recipe_app/screens/home/recipe_click_screen.dart';
import 'package:recipe_app/size_config.dart';

import 'categories.dart';
import 'recipe_bundel_card.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Categories()
      );
  }
}