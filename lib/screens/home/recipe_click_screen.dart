import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_app/components/my_bottom_nav_bar.dart';
import 'package:recipe_app/screens/home/components/recipe_card.dart';
import 'package:recipe_app/screens/profile/prrofile_screen.dart';
import 'package:recipe_app/size_config.dart';

import '../../recipe_search/screen/first_screen.dart';

class RecipeDisplay extends StatelessWidget {
  //List<String> menutexts = ["Home","Search Recipes","Click photo","Favourites", "Contact us"];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text("Menu")
              ),
              // ListView.builder(itemCount: menutexts.length,itemBuilder: (BuildContext context,i){
              //   return ListTile(
              //     title: Text(menutexts[i]),
              //   );
              // }),
              ListTile(
                title: const Text("Home"),
                onTap:(){
                  Navigator.pop(context);
                } ,
              ),
              ListTile(
                title: const Text("Search Recipes"),
                onTap:(){
                  Navigator.pop(context);
                } ,
              ),
              ListTile(
                title: const Text("Click photo"),
                onTap:(){
                  Navigator.pop(context);
                } ,
              ),
              ListTile(
                title: const Text("Profile"),
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen()));
                } ,
              ),
              ListTile(
                title: const Text("Favourites"),
                onTap:(){
                  Navigator.pop(context);
                } ,
              ),
              ListTile(
                title: const Text("Contact us"),
                onTap:(){
                  Navigator.pop(context);
                } ,
              ),
          ],    
        ),
      ),
      appBar: buildAppBar(context),
      body: RecipeCard(),
      bottomNavigationBar: MyBottomNavBar(),
    );

    
  }

  AppBar buildAppBar(BuildContext context) {
     return AppBar(
      // leading: IconButton(
      //   icon: SvgPicture.asset("assets/icons/menu.svg"),
      //   onPressed: () {},
      // ),
      // On Android by default its false
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
