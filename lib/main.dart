import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:hrvms_attendence/RegistrationUI/register_ui.dart';
import 'package:hrvms_attendence/loginUI/landingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LandingScreen(),
    );
  }
}
