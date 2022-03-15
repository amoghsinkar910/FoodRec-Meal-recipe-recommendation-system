import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickPage extends StatefulWidget {
  
  @override
  State<ImagePickPage> createState() => _ImagePickPageState();
}

class _ImagePickPageState extends State<ImagePickPage> {

  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker",style: TextStyle(color: Colors.black),) ,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imageFile!=null)
              Container(
                height: 480,
                width: 600,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover
                  ),
                  border: Border.all(width: 8,color: Colors.black12),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              )
            else
            Container(
              height: 480,
              width: 600,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 8,color: Colors.black12),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Text("Image will appear here",style: TextStyle(fontSize: 20),),
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      getImage(Source: ImageSource.camera);
                    }, 
                  child: const Text("Capture", style: TextStyle(fontSize: 18),)
                  ),
                ),
                const SizedBox(width: 10,),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      getImage(Source: ImageSource.gallery);
                    }, 
                  child: const Text("Gallery", style: TextStyle(fontSize: 18),)
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      
                    }, 
                  child: const Text("Next", style: TextStyle(fontSize: 18),)
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      
    );
  }
  void getImage({ImageSource Source}) async {

    final file = await ImagePicker().pickImage(
      source: Source,
      maxHeight: 480,
      maxWidth: 600,
      imageQuality: 70,
      );
    if(file?.path!=null)
    {
      setState(() {
        imageFile = File(file.path);
      });
    }
  }
}

