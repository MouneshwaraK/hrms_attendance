import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:hrvms_attendence/loginUI/LoginUI.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  runApp(const LoginUI());
}
