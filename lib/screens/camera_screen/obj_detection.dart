import 'package:flutter/material.dart';
import '../../components/my_bottom_nav_bar.dart';
import 'pick_image_screen.dart';

class TextInputScreen extends StatelessWidget {
  TextInputScreen(this.output);
  final List output;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingredients'),),
      body: ListView.builder(
        itemCount: output.length,
        itemBuilder: (context, int index){
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children:<Widget> [
                  Text(output[index],
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 20,
                  ),
                  )  
              ]
              ),
            ),
          );
        }
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}