import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:hrvms_attendence/Utils/images.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  File? _capturedImage;

  late FaceCameraController controller;
  bool isFaceDetected = false;
  bool isImageCaptured = false; // New flag to prevent multiple captures

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initializeCameraFun();
  }

  void initializeCameraFun() {
    controller = FaceCameraController(
      autoCapture: false, // Disable auto-capture to validate face first
      defaultCameraLens: CameraLens.front,
      performanceMode: FaceDetectorMode.accurate,
      onCapture: (File? image) {
        setState(() {
          _capturedImage = image;
        });
        if (image != null) {
          // Upload the image
          uploadImage(image);
        }
        print("Image captured: ${_capturedImage?.path}");
      },
      onFaceDetected: (Face? face) {
        if (face != null && _isFaceValid(face)) {
          setState(() {
            isFaceDetected = true;
          });
          controller.captureImage(); // Capture image only if valid
        } else {
          setState(() {
            isFaceDetected = false;
          });
          // Provide error feedback for invalid detection
          flutterTts.speak(
              "Invalid face detected. Please position your face properly.");
          print('Invalid face detected.');
        }
      },
    );

    controller.initialize(); // Initialize the controller
  }

// Check for essential landmarks
  bool _isFaceValid(Face face) {
    FaceLandmark? leftEye = face.landmarks[FaceLandmarkType.leftEye];
    FaceLandmark? rightEye = face.landmarks[FaceLandmarkType.rightEye];
    FaceLandmark? noseBase = face.landmarks[FaceLandmarkType.noseBase];

    bool hasEssentialLandmarks =
        leftEye != null && rightEye != null && noseBase != null;

    return hasEssentialLandmarks;
  }

  void _refreshScreen() {
    setState(() {
      _capturedImage = null;
      isFaceDetected = false;
      isImageCaptured = false; // Reset the flag on refresh
    });
    initializeCameraFun();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void uploadImage(File image) async {
    try {
      // Create a multipart request
      final uri = Uri.parse('https://your-server-url.com/upload');
      final request = http.MultipartRequest('POST', uri);

      // Add the image file as a multipart file
      final file = await http.MultipartFile.fromPath(
        'image', // The name of the field in your backend
        image.path,
        contentType: MediaType('image', 'jpeg'), // Set content type if needed
      );
      request.files.add(file);

      // Add other fields if needed
      request.fields['user_id'] = '12345'; // Example of adding extra data

      // Send the request
      final response = await request.send();

      // Check response
      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        // Navigate to the next screen
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
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
            WidgetsBinding.instance.addPostFrameCallback((_) {
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
            showCaptureControl: true,
            indicatorShape: IndicatorShape.defaultShape,
            messageBuilder: (context, face) {
              if (face == null) {
                flutterTts
                    .speak("No face detected. Place your face in the camera.");
                return _message(
                    'No face detected. Place your face in the camera.');
              } else if (!face.wellPositioned) {
                flutterTts.speak("Center your face in the square");
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
}
