import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_app/components/my_bottom_nav_bar.dart';
import 'package:recipe_app/screens/home/components/body.dart';
import 'package:recipe_app/screens/login/login_screen.dart';
import 'package:recipe_app/screens/profile/prrofile_screen.dart';
import 'package:recipe_app/size_config.dart';


class HomeScreen extends StatelessWidget {
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
              ListTile(
                title: const Text("Logout"),
                onTap:()async{
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=>LoginScreen())
                  );
                } ,
              ),
          ],    
        ),
      ),
      appBar: buildAppBar(),
      body: Body(),
      // We are not able to BottomNavigationBar because the icon parameter dont except SVG
      // We also use Provied to manage the state of our Nav
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
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
          onPressed: () {},
        ),
        SizedBox(
          // It means 5 because by out defaultSize = 10
          width: SizeConfig.defaultSize * 0.5,
        )
      ],
    );
  }
}
