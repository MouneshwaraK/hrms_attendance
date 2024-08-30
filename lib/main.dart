import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:hrvms_attendence/Attendence_UI/successful_checked_in_user.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:hrvms_attendence/Utils/images.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _capturedImage;

  late FaceCameraController controller;
  bool isFaceDetected = false;

  @override
  void initState() {
    super.initState();
    initializeCameraFun();
  }

  void initializeCameraFun() {
    controller = FaceCameraController(
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      performanceMode: FaceDetectorMode.fast,
      onCapture: (File? image) {
        setState(() {
          _capturedImage = image;
        });
        if (image != null) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SuccessfulCheckinUserUI(
                  imagePath: _capturedImage!.path,
                ),
              ),
            );
          });
        }
        print("Image captured: ${_capturedImage?.path}");
      },
      onFaceDetected: (Face? face) {
        setState(() {
          isFaceDetected = face != null;
        });
        if (face != null) {
          // Capture immediately when a face is detected
          controller.captureImage();
        }
      },
    );
    controller.initialize(); // Initialize the controller
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FaceCamera app'),
        ),
        body: Builder(builder: (context) {
          if (_capturedImage != null) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              _navigateToSuccessfulCheckinScreen(context, _capturedImage);
            });
          } else {
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetImages.logo,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.66,
                    height: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: ColorConst().lightRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Oops..! Checked in failed.\n Unauthorized User",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                          Image.asset(
                            AssetImages.failedUser,
                            width: 273,
                            height: 273,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text(
                                "Try again",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return SmartFaceCamera(
            controller: controller,
            showFlashControl: false,
            showCameraLensControl: false,
            showCaptureControl: false,
            messageBuilder: (context, face) {
              if (face == null) {
                return _message('Place your face in the camera');
              }
              if (!face.wellPositioned) {
                return _message('Center your face in the square');
              }
              return const SizedBox.shrink();
            },
          );
        }),
      ),
    );
  }

  Future<void> _navigateToSuccessfulCheckinScreen(
      BuildContext context, File? capturedImage) async {
    // Ensure _capturedImage is not null before navigating
    if (_capturedImage != null) {
      // await Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => SuccessfulCheckinUserUI(
      //       imagePath: _capturedImage!.path,
      //     ),
      //   ),
      // );
      showAlertDialog(context); // Call the method to show AlertDialog
    } else {
      // Handle the case where _capturedImage is null
      print('Error: _capturedImage is null.');
    }
  }

  // Method to show the AlertDialog
  void showAlertDialog(BuildContext context) {
    // Set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
        _refreshScreen();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
        _refreshScreen();
      },
    );

    // Set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("HRVMS"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  AssetImages.logo,
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.66,
                  height: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: ColorConst().blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Check In \n Completed Successfully",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600),
                      ),
                      Stack(
                        children: [
                          Container(),
                          Center(
                            child: Image.asset(
                              AssetImages.celebrationsBg,
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.width * 0.4,
                            ),
                          ),
                          Positioned(
                            bottom: 80,
                            left: 160,
                            child: CircleAvatar(
                              radius: 100,
                              child: ClipOval(
                                child: Image.file(
                                  _capturedImage!,
                                  fit: BoxFit.cover,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.width * 0.3,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            _refreshScreen();
                          },
                          child: const Text(
                            "Thank you",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _refreshScreen() {
    setState(() {
      _capturedImage = null;
      isFaceDetected = false;
    });
    initializeCameraFun();
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
