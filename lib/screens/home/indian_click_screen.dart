// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:recipe_app/components/my_bottom_nav_bar.dart';
// import 'package:recipe_app/screens/home/components/indian_card.dart';
// import 'package:recipe_app/screens/profile/prrofile_screen.dart';
// import 'package:recipe_app/size_config.dart';

// import 'components/categories.dart';

// class RecipeDisplay extends StatelessWidget {
//   //List<String> menutexts = ["Home","Search Recipes","Click photo","Favourites", "Contact us"];
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
      
//       appBar: buildAppBar(),
//       body: RecipeCard(),
//       bottomNavigationBar: MyBottomNavBar(),
//     );

    
//   }

//   AppBar buildAppBar() {  
//     return AppBar(
//       iconTheme: IconThemeData(color: Colors.black),
//       centerTitle: true,
//       //title: Image.asset("assets/images/logo.png"),
//       title: Text("Popular Recipes",
//             style: TextStyle(
//               color: Colors.black87,
//               fontSize: 24,
//             ),
//         ),
//       actions: <Widget>[
//         IconButton(
//           icon: SvgPicture.asset("assets/icons/search.svg"),
//           onPressed: () {},
//         ),
//         SizedBox(
//           width: SizeConfig.defaultSize * 0.5,
//         )
//       ],
//     );
//   }  
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_app/components/my_bottom_nav_bar.dart';
import 'package:recipe_app/screens/home/components/body.dart';
import 'package:recipe_app/screens/home/components/category_list.dart';
import 'package:recipe_app/screens/home/components/indian_card.dart';
import 'package:recipe_app/screens/login/login_screen.dart';
import 'package:recipe_app/screens/profile/prrofile_screen.dart';
import 'package:recipe_app/size_config.dart';

import '../../recipe_search/screen/first_screen.dart';


class IndianRecipeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            CategoryList(),
            RecipeCard(),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Image.asset("assets/images/logo.png"),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
          },
        ),
        SizedBox(
          // It means 5 because by out defaultSize = 10
          width: SizeConfig.defaultSize * 0.5,
        )
      ],
    );
  }
}

