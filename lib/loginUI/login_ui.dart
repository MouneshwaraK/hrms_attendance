import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hrvms_attendence/Utils/Api/api_service.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:hrvms_attendence/Utils/images.dart';
import 'package:image/image.dart' as img;

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  File? _capturedImage;

  late FaceCameraController controller;
  bool isFaceDetected = false;
  bool isImageCaptured = false;
  Timer? debounceTimer; // Timer to debounce face detection
  bool hasSpoken = false; // Prevent repeated actions

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
          isImageCaptured = false; // Reset the flag after capture
        });
        if (image != null) {
          uploadImage(image);
        }
      },
      onFaceDetected: (Face? face) async {
        if (face != null && _isFaceValid(face)) {
          if (!isImageCaptured) {
            setState(() {
              isImageCaptured = true; // Prevent further captures
            });

            // Capture the image
            controller.captureImage();

            // Reset the flag after processing
            await Future.delayed(const Duration(
                seconds: 1)); // Small delay to avoid quick resets
            setState(() {
              isImageCaptured = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isFaceDetected = false;
              isImageCaptured = false;
            });
            flutterTts.speak(
                "Invalid face detected. Please position your face properly.");
          }
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

    return leftEye != null && rightEye != null && noseBase != null;
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
    flutterTts.stop(); // Stop any ongoing TTS
    super.dispose();
  }

  void uploadImage(File image) async {
    try {
      img.Image originalImage = img.decodeImage(await image.readAsBytes())!;
      img.Image resizedImage = img.copyResize(originalImage, width: 800);
      File compressedFile = File(image.path)
        ..writeAsBytesSync(img.encodeJpg(resizedImage));
      List<int> compressedImageBytes = await compressedFile.readAsBytes();
      String base64Image = base64Encode(compressedImageBytes);
      String prefixedBase64Image = "data:image/jpeg;base64,$base64Image";
      Map<String, dynamic> payload = {
        "image": prefixedBase64Image,
      };

// Call the login API
      Response response = await ApiService().validateUser(
        url: "http://34.228.44.206:8000/face_recognition/",
        reqObj: jsonEncode(payload),
        device_status: "in", // Provide the required device_status argument
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        String name = responseData['recognized_face_data']['name'];
        String message = "Thank you, $name!";
        await flutterTts.speak(message);
        _showInvalidUserUI();
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _refreshScreen();
          }
        });
        setState(() {
          isFaceDetected = true;
        });
      } else {
        print("Error: ${response.statusCode} - ${response.statusMessage}");
        print("Response body: ${response.data}");
        await flutterTts.speak("Invalid User Please try again.");
        _showInvalidUserUI();
      }
    } on DioException catch (e) {
      print("Dio error occurred: ${e.message}");
      await flutterTts.speak("Invalid User Please try again.");
      _showInvalidUserUI();
    } catch (e) {
      print("Unexpected error: $e");
      await flutterTts.speak("Invalid User Please try again.");
      _showInvalidUserUI();
    }
  }

  void _showInvalidUserUI() {
    setState(() {
      _capturedImage = null;
      isFaceDetected = false;
      isImageCaptured = false;
      _refreshScreen();
    });
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
              // _navigateToSuccessfulCheckinScreen(context, _capturedImage);
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
                debounceTimer
                    ?.cancel(); // Cancel timer when no face is detected
                if (!hasSpoken) {
                  flutterTts.speak(
                      "No face detected. Place your face in the camera.");
                  updateStateSafely(() {
                    hasSpoken = true;
                  });
                }
                return _message('No face detected');
              } else if (!face.wellPositioned) {
                if (!hasSpoken) {
                  flutterTts.speak("Center your face in the square");
                  // Set a cooldown timer to avoid repeated actions
                  debounceTimer?.cancel();
                  debounceTimer = Timer(Duration(seconds: 2), () {
                    updateStateSafely(() {
                      hasSpoken = false;
                    });
                  });
                  updateStateSafely(() {
                    hasSpoken = true;
                  });
                }

                return _message('Center your face in the square');
              }

              // Reset the flag when the face is well-positioned
              debounceTimer?.cancel();
              updateStateSafely(() {
                hasSpoken = false;
              });

              return const SizedBox.shrink();
            },
          );
        }),
      ),
    );
  }

  void updateStateSafely(Function updateAction) {
    // Ensures state updates are safe and do not conflict with the build process
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          updateAction();
        });
      }
    });
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
