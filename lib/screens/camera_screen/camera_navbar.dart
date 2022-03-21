import 'package:flutter/material.dart';
import 'package:recipe_app/components/my_bottom_nav_bar.dart';
import 'package:camera/camera.dart';
import 'package:recipe_app/constants.dart';
import 'package:recipe_app/screens/camera_screen/pick_image_screen.dart';
import 'package:recipe_app/screens/camera_screen/yolo_detect.dart';
import 'package:recipe_app/screens/test_detection/home.dart';
import 'package:recipe_app/size_config.dart';

class CameraScreen extends StatefulWidget {
  
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  
  @override
  // void initState() {
  //   super.initState();
  //    WidgetsFlutterBinding.ensureInitialized();
  //   try {
  //     cameras = availableCameras();
  //   } on CameraException catch (e) {
  //     print('Error: $e.code\nError Message: $e.message');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      //body: ImagePickPage(),
      body: TfliteHome(),
      //body: HomePage(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}