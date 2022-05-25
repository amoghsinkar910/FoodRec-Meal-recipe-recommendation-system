import 'package:flutter/material.dart';
import '../../../models/PopularRecipes.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../models/IndianRecipes.dart';
import '../../../recipe_search/RecipeView.dart';
import '../../../recipe_search/model.dart';
import '../../../size_config.dart';

class FoodCourtCard extends StatefulWidget {
  @override
  _FoodCourtCardState createState() => _FoodCourtCardState();
}

class _FoodCourtCardState extends State<FoodCourtCard> {
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  
  getRecipes() async {
    String query = "food court";
    String url =
        "https://api.edamam.com/search?q=${query}&app_id=05197bfe&app_key=c6660c6d1516b97f1ff8402daf6430fa";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = new RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading = false;
        });
        log(recipeList.toString());
      });
    });


    recipeList.forEach((Recipe) {
      print(Recipe.applabel);
      print(Recipe.appcalories);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:<Widget> [
                SafeArea(
                    child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: recipeList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeView(recipeList[index].appurl)));
                                  },
                                  child: Card(
                                    margin: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0.0,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child: Image.network(
                                              recipeList[index].appimgUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 200,
                                            )),
                                        Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.black26),
                                                child: Text(
                                                  recipeList[index].applabel,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ))),
                                        Positioned(
                                          right: 0,
                                          height: 40,
                                          width: 80,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(10),
                                                      bottomLeft: Radius.circular(10)
                                                  )
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.local_fire_department, size: 15,),
                                                    Text(recipeList[index].appcalories.toString().substring(0, 6)),
                                                  ],
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                            ),            
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}