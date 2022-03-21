import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/screens/camera_screen/obj_detection.dart';
import 'package:tflite/tflite.dart';

class ImagePickPage extends StatefulWidget {
  
  @override
  State<ImagePickPage> createState() => _ImagePickPageState();
}

class _ImagePickPageState extends State<ImagePickPage> {

  File imageFile;
  bool _loading = true;
  File image;
  List _output;

  @override
  void initState(){
    super.initState();
    loadModel().then((value){
      setState(() {});
    });
  }

  @override
  void dispose() async{
    //dis function disposes and clears our memory
    super.dispose();
    await Tflite.close();
  }

  classifyImage(File image) async {
    //this function runs the model on the image
    var output = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "YOLO",
      imageMean: 127.5,     
      imageStd: 127.5,      
      asynch: true  
    );
    print("####################");
    print(output);
    setState(() {
      _output = output;
      _loading = false;
    });
    //getOutput();
  }

  loadModel () async{
    await Tflite.loadModel(
      model: 'assets/models/synfruits/fruit_model.tflite',
      labels: 'assets/models/synfruits/image_labels.txt',
      );
  }


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
                height: 380,
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
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=>TextInputScreen(_output))
                      );
                    }, 
                  child: const Text("Next", style: TextStyle(fontSize: 18),)
                  ),
                ),
              ],
            ),
            Expanded(child: Text(
              'output',style: TextStyle(fontSize: 20, color: Colors.black),
              )
            ),
            //Text('The ingredients in the image are ${_output[0]['detectedClass']}')),
          ],
        ),
      ),
      
    );
  }
  void getImage({ImageSource Source}) async {

    final file = await ImagePicker().pickImage(
      source: Source,
      maxHeight: 380,
      maxWidth: 600,
      imageQuality: 70,
      );
    if(file?.path!=null)
    {
      setState(() {
        imageFile = File(file.path);
      });
      classifyImage(imageFile);
    }
  }

  void getOutput(){
    print("########################################");
    print(_output);
  }
}

