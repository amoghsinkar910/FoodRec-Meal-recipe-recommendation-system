import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'classifierYolov4.dart';

import '../../recipe_search/search.dart';

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class TfliteHome extends StatefulWidget {
  @override
  _TfliteHomeState createState() => _TfliteHomeState();
}

class _TfliteHomeState extends State<TfliteHome> {
  Classifier classifier = Classifier();
  String _model = ssd;
  File _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;

  List _recognitions;

  @override
  void initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      if (_model == yolo) {
        res = await Tflite.loadModel(
          model: "assets/ssd/yolov2_tiny.tflite",
          labels: "assets/ssd/yolov2_tiny.txt",
        );
      } else {
        res = await Tflite.loadModel(
          model: "assets/ssd/ssd_mobilenet.tflite",
          labels: "assets/ssd/ssd_mobilenet.txt",
        );
      }
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  selectFromImagePicker() async {
    //var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    final path = image.path;
    final bytes = await File(path).readAsBytes();
    final img.Image imagenew = img.decodeImage(bytes);
    print("##########");
    print(classifier.predict(imagenew));
  }

  selectFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    final path = image.path;
    final bytes = await File(path).readAsBytes();
    final img.Image imagenew = img.decodeImage(bytes);
    print("##########");
    print(classifier.predict(imagenew));
  }

  // predictImage(File image) async {
  //   if (image == null) return;

  //   if (_model == yolo) {
  //     await yolov2Tiny(image);
  //   } else {
  //     await ssdMobileNet(image);
  //   }

  //   FileImage(image)
  //       .resolve(ImageConfiguration())
  //       .addListener((ImageStreamListener((ImageInfo info, bool _) {
  //         setState(() {
  //           _imageWidth = info.image.width.toDouble();
  //           _imageHeight = info.image.height.toDouble();
  //         });
  //       })));

  //   setState(() {
  //     _image = image;
  //     _busy = false;
  //   });
  // }

  yolov2Tiny(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "YOLO",
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);
    print(recognitions);
    setState(() {
      _recognitions = recognitions;
    });
  }

  ssdMobileNet(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);
    
    print(recognitions);
    setState(() {
      _recognitions = recognitions;
    });
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageHeight * screen.width;

    Color blue = Colors.red;

    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: blue,
            width: 3,
          )),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<String> nextWidget(){
    List<String> b=[];   
    if(_recognitions!=null)
    {
      _recognitions.map((re) {
        print("##############################");
        print(re['detectedClass']);
        print(re['detectedClass'].runtimeType);
      b.add("${re['detectedClass']}");
      }).toList();
      print(b);
    }
    return b;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: _image == null ? SafeArea(
        child: Row(
          children:<Widget> [
            const SizedBox(width: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Please click an image",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              ),
          ],
        ),
        )
       : Image.file(_image),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("TFLite Demo"),
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            SizedBox(width: MediaQuery.of(context).size.width*0.22),
            FloatingActionButton(
              child: Icon(Icons.add_a_photo),
              tooltip: "Capture image from camera",
              onPressed: selectFromImagePicker,
            ),
            const SizedBox(width: 30,),
            FloatingActionButton(
              child: Icon(Icons.add),
              tooltip: "Pick Image from gallery",
              onPressed: selectFromGallery,
            ),
            const SizedBox(width: 30,),
            FloatingActionButton(
          child: Text("Next"),
          tooltip: "Go Next",
          onPressed: (){
            List<String> ingr = nextWidget();
            Navigator.push(
              context, 
            MaterialPageRoute(
              builder: (context)=>Search(ingr.join(","))));
          },
         ),
          ],
        ),
      ),
      body: Stack(
        children: stackChildren,
      ),
    );
  }
}


// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:tflite/tflite.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'nextpage.dart';
// import 'package:recipe_app/recipe_search/search.dart';

// const String ssd = "SSD MobileNet";
// const String yolo = "Tiny YOLOv2";

// class TfliteHome extends StatefulWidget {
//   @override
//   _TfliteHomeState createState() => _TfliteHomeState();
// }

// class _TfliteHomeState extends State<TfliteHome> {
//   String _model = ssd;
//   File _image;

//   double _imageWidth;
//   double _imageHeight;
//   bool _busy = false;

//   List _recognitions;

//   @override
//   void initState() {
//     super.initState();
//     _busy = true;

//     loadModel().then((val) {
//       setState(() {
//         _busy = false;
//       });
//     });
//   }

//   loadModel() async {
//     Tflite.close();
//     try {
//       String res;
//       if (_model == yolo) {
//         res = await Tflite.loadModel(
//           model: "assets/ssd/yolov2_tiny.tflite",
//           labels: "assets/ssd/yolov2_tiny.txt",
//         );
//       } else {
//         res = await Tflite.loadModel(
//           model: "assets/ssd/ssd_mobilenet.tflite",
//           labels: "assets/ssd/ssd_mobilenet.txt",
//         );
//       }
//       print(res);
//     } on PlatformException {
//       print("Failed to load the model");
//     }
//   }

//   selectFromImagePicker() async {
//     //var image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     var image = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (image == null) return;
//     setState(() {
//       _busy = true;
//     });
//     predictImage(File(image.path));
//   }

//   predictImage(File image) async {
//     if (image == null) return;

//     if (_model == yolo) {
//       await yolov2Tiny(image);
//     } else {
//       await ssdMobileNet(image);
//     }

//     FileImage(image)
//         .resolve(ImageConfiguration())
//         .addListener((ImageStreamListener((ImageInfo info, bool _) {
//           setState(() {
//             _imageWidth = info.image.width.toDouble();
//             _imageHeight = info.image.height.toDouble();
//           });
//         })));

//     setState(() {
//       _image = image;
//       _busy = false;
//     });
//   }

//   yolov2Tiny(File image) async {
//     var recognitions = await Tflite.detectObjectOnImage(
//         path: image.path,
//         model: "YOLO",
//         threshold: 0.3,
//         imageMean: 0.0,
//         imageStd: 255.0,
//         numResultsPerClass: 1);

//     setState(() {
//       _recognitions = recognitions;
//     });
//   }

//   ssdMobileNet(File image) async {
//     var recognitions = await Tflite.detectObjectOnImage(
//         path: image.path, numResultsPerClass: 1);

//     setState(() {
//       _recognitions = recognitions;
//     });
//   }

//   List<Widget> renderBoxes(Size screen) {
//     if (_recognitions == null) return [];
//     if (_imageWidth == null || _imageHeight == null) return [];

//     double factorX = screen.width;
//     double factorY = _imageHeight / _imageHeight * screen.width;

//     Color blue = Colors.red;

//     return _recognitions.map((re) {
//       return Positioned(
//         left: re["rect"]["x"] * factorX,
//         top: re["rect"]["y"] * factorY,
//         width: re["rect"]["w"] * factorX,
//         height: re["rect"]["h"] * factorY,
//         child: Container(
//           decoration: BoxDecoration(
//               border: Border.all(
//             color: blue,
//             width: 3,
//           )),
//           child: Text(
//             "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
//             style: TextStyle(
//               background: Paint()..color = blue,
//               color: Colors.white,
//               fontSize: 15,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }

//   List<String> nextWidget(){
//     List<String> b=[];   
//     if(_recognitions!=null)
//     {
//       _recognitions.map((re) {
//         print("##############################");
//         print(re['detectedClass']);
//         print(re['detectedClass'].runtimeType);
//       b.add("${re['detectedClass']}");
//       }).toList();
//       print(b);
//     }
    
//     return b;
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     List<Widget> stackChildren = [];

//     stackChildren.add(Positioned(
//       top: 0.0,
//       left: 0.0,
//       width: size.width,
//       child: _image == null ? SafeArea(
//         child: Row(
//           children:<Widget> [
//             const SizedBox(width: 20,),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text("Please click an image",
//                 style: TextStyle(fontSize: 20, color: Colors.black),
//               ),
//               ),
//           ],
//         ),
//         )
//        : Image.file(_image),
//     ));

//     stackChildren.addAll(renderBoxes(size));

//     if (_busy) {
//       stackChildren.add(Center(
//         child: CircularProgressIndicator(),
//       ));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("TFLite Demo"),
//         centerTitle: true,
//       ),      
//       body: Row(
//         children: [
//          FloatingActionButton(
//           child: Icon(Icons.add_a_photo),
//           tooltip: "Pick Image from gallery",
//           onPressed: selectFromImagePicker,
//          ),
//          FloatingActionButton(
//           child: Text("Next"),
//           tooltip: "Go Next",
//           onPressed: (){
//             List<String> ingr = nextWidget();
//             Navigator.push(
//               context, 
//             MaterialPageRoute(
//               builder: (context)=>Search(ingr.join(","))));
//           },
//          ),
//          Stack(
//            children: stackChildren,
//           ),
//         ],
//       ),
//     );
//   }
// }

