import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:recipe_app/screens/home/indian_click_screen.dart';


class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<String> categories = ["All", "Indian", "Italian", "Mexican", "Chinese"];
  int selectedIndex = 0,idx=0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ListEntry(categories[0]),
        ListEntry(categories[1]),
        ListEntry(categories[2]),
        ListEntry(categories[3]),
      ],
    );
  }
}

Container ListEntry(String category){
  return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: SizeConfig.defaultSize * 2),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.defaultSize * 2, //20
          vertical: SizeConfig.defaultSize * 0.5, //5
        ),
        decoration: BoxDecoration(
          color:Color(0xFFEFF3EE),
            borderRadius: BorderRadius.circular(
              SizeConfig.defaultSize * 1.6, // 16
            )
        ),
        child: Text(
          category,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:Color(0xFFC2C2B5),
          ),
        ),
      );
}
