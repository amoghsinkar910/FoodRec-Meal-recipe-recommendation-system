import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
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

  String _byte64imagecode;
  double _count = 0;
  double _imageWidth;
  double _imageHeight;
  bool _busy = false;

  List _recognitions;
  List<String> _detectedFoods;

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
    // String response = postRequest(ext, base64Image).toString();
    print("%%%%%%%%%%%%%%%%");
    postRequest(ext, base64Image);
    String response = await postRequest(ext, base64Image);
    // String response='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';
    // String response=base64Image;
    print("%%%%%%%%%%%%%%%%");
    print(response);
    // Image(base64Decode('${response["imString"]}'));
    final dec = base64Decode(response);
    final directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/testImage${_count}.jpg');
    file.writeAsBytesSync(dec);
    setState(() {
      _count = _count + 1;
    });
    // Image.file(file);
    predictImage(file);
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
    String response = await postRequest(ext, base64Image);
    // String response='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';
    // String response=base64Image;
    print("%%%%%%%%%%%%%%%%");
    print(response);
    // Image(base64Decode('${response["imString"]}'));
    final dec = base64Decode(response);
    final directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/testImage${_count}.jpg');
    file.writeAsBytesSync(dec);
    setState(() {
      _count = _count + 1;
    });
    // Image.file(file);
    predictImage(file);
  }

  predictImage(File image) async {
    if (image == null) return;

    // if (_model == yolo) {
    //   await yolov2Tiny(image);
    // } else {
    //   await ssdMobileNet(image);
    // }

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
    // String url = 'http://192.168.141.121:5000/detect';
    String url = 'http://192.168.18.121:5000/detect';

    Map data = {"base64": base64, "type": ext};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    //print("${response.statusCode}");
    print("${response.body}");
    Map<String, dynamic> temp = json.decode(response.body);
    //print(temp);
    //print(temp['imString']);
    print(temp['imString']
        .substring(temp['imString'].length - 40, temp['imString'].length));

    setState(() {
      String detectedfoods = '${temp['foods']}';
      _detectedFoods = detectedfoods.split('_');
      // _byte64imagecode = '${temp['imString']}';
    });

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
    // if (_recognitions != null) {
    //   _recognitions.map((re) {
    //     print("##############################");
    //     print(re['detectedClass']);
    //     print(re['detectedClass'].runtimeType);
    //     if ("${re['detectedClass']}" == "banana" ||
    //         "${re['detectedClass']}" == "apple" ||
    //         "${re['detectedClass']}" == "orange" ||
    //         "${re['detectedClass']}" == "broccoli" ||
    //         "${re['detectedClass']}" == "carrot") {
    //       b.add("${re['detectedClass']}");
    //     }
    //   }).toList();
    //   print(b);
    // }
    b = _detectedFoods;
    print(b);
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
