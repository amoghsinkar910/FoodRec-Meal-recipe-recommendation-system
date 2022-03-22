import 'package:flutter/material.dart';


class NextPage extends StatelessWidget {
  const NextPage({ Key key, this.ingredients}) : super(key: key);
  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
    print("@@@@@@@@@@@@@@@");
    print(ingredients);
    return Scaffold(
      body: ListView.builder(
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(ingredients[index],
          style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          );
          },
        ),
    );
  }
}


