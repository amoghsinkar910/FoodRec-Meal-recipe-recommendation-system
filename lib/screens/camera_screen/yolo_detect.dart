import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../recipe_search/search.dart';

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class TfliteHome extends StatefulWidget {
  @override
  _TfliteHomeState createState() => _TfliteHomeState();
}

class _TfliteHomeState extends State<TfliteHome> {
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
    print(image.path);
    print("Test");
    String ext = image.path.split(".").last;
    print(ext);
    File imagefile = File(image.path);

    List<int> imageBytes = imagefile.readAsBytesSync();
    // print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    print(base64Image.substring(0, 20));
    String response = postRequest(ext, base64Image).toString();
    print("%%%%%%%%%%%%%%%%");
    print(response);
    // Image(base64Decode('${response["imString"]}'));
    final dec = base64Decode(response);
    var file = File("temp.jpg");
    file.writeAsBytes(dec);
    Image.file(file);
  }

  selectFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    print("##################");
    print(image.path);
    print("Test");
    String ext = (image.path.split(".").last);
    print(ext);
    File imagefile = File(image.path);
    List<int> imageBytes = imagefile.readAsBytesSync();
    // print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    String response = postRequest(ext, base64Image).toString();
    print("%%%%%%%%%%%%%%%%");
    print(response);
    // Image(base64Decode('${response["imString"]}'));
    final dec = base64Decode(response);
    var file = File("temp.jpg");
    file.writeAsBytes(dec);
    Image.file(file);
    // predictImage(File(image.path));
  }

  predictImage(File image) async {
    if (image == null) return;

    if (_model == yolo) {
      await yolov2Tiny(image);
    } else {
      await ssdMobileNet(image);
    }

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  Future<String> postRequest(String ext, String base64) async {
    print('*****Call to function postRequest*********');
    String url = 'http://192.168.139.121:5000/detect';

    Map data = {"base64": base64, "type": ext};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    Map<String, dynamic> temp = json.decode(response.body);
    print(temp);
    print(temp['imString']);
    return '${temp['imString']}';
  }

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

  List<String> nextWidget() {
    List<String> b = [];
    if (_recognitions != null) {
      _recognitions.map((re) {
        print("##############################");
        print(re['detectedClass']);
        print(re['detectedClass'].runtimeType);
        if ("${re['detectedClass']}" == "banana" ||
            "${re['detectedClass']}" == "apple" ||
            "${re['detectedClass']}" == "orange" ||
            "${re['detectedClass']}" == "broccoli" ||
            "${re['detectedClass']}" == "carrot") {
          b.add("${re['detectedClass']}");
        }
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
      child: _image == null
          ? SafeArea(
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Please click an image",
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
            SizedBox(width: MediaQuery.of(context).size.width * 0.22),
            FloatingActionButton(
              child: Icon(Icons.add_a_photo),
              tooltip: "Capture image from camera",
              onPressed: selectFromImagePicker,
            ),
            const SizedBox(
              width: 30,
            ),
            FloatingActionButton(
              child: Icon(Icons.add),
              tooltip: "Pick Image from gallery",
              onPressed: selectFromGallery,
            ),
            const SizedBox(
              width: 30,
            ),
            FloatingActionButton(
              child: Text("Next"),
              tooltip: "Go Next",
              onPressed: () {
                List<String> ingr = nextWidget();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Search(ingr.join(","))));
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

