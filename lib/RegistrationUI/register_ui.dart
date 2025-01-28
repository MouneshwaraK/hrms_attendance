import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hrvms_attendence/Utils/Api/api_service.dart';
import 'package:hrvms_attendence/Utils/UpperCaseTextFormatter.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class RegistrationUI extends StatefulWidget {
  const RegistrationUI({super.key});

  @override
  State<RegistrationUI> createState() => _RegistrationUIState();
}

class _RegistrationUIState extends State<RegistrationUI> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController empCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _image;
  File? file;
  FlutterTts flutterTts = FlutterTts();
  bool isLoading = false;
  final ImagePicker _picker =
      ImagePicker(); // Declare and initialize the ImagePicker

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 80),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: MediaQuery.of(context).size.height * 0.1,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'EMPLOYEE REGISTRATION',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // GestureDetector(
                //   onTap: () => _clickImage(context),
                //   child: Container(
                //     margin: const EdgeInsets.all(10),
                //     width: screenWidth * 0.3,
                //     height: screenWidth * 0.3,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Colors.black12,
                //       border: Border.all(color: Colors.black26, width: 1.5),
                //     ),
                //     child: _image == null
                //         ? const Icon(
                //             Icons.person,
                //             size: 70,
                //             color: Colors.white,
                //           )
                //         : ClipOval(
                //             child: Image.file(
                //               File(_image!.path),
                //               fit: BoxFit.cover,
                //               width: screenWidth * 0.3,
                //               height: screenWidth * 0.3,
                //             ),
                //           ),
                //   ),
                // ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _clickImage(context),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                          border: Border.all(color: Colors.black26, width: 1.5),
                        ),
                        child: Stack(
                          alignment: Alignment.center, // Center the image/icon
                          children: [
                            // Show the person icon or the selected image
                            ClipOval(
                              child: _image == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 70,
                                      color: Colors.white,
                                    )
                                  : Image.file(
                                      File(_image!.path),
                                      fit: BoxFit
                                          .cover, // Ensure the image fills the circle
                                      width: screenWidth * 0.3,
                                      height: screenWidth * 0.3,
                                    ),
                            ),
                            // Add "+" icon in the top-right corner
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                        height:
                            10), // Add spacing between the image and the text
                    const Text(
                      "Please upload a photo",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: firstnameController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter First Name";
                    }
                    // Regular expression to match only letters and spaces
                    RegExp regExp = RegExp(r'[a-zA-Z\s]+$');

                    if (!regExp.hasMatch(value)) {
                      return "Please enter only letters and spaces";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                    UpperCaseTextFormatter(),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: "First Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: lastnameController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter Last Name";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                    UpperCaseTextFormatter(),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: "Last Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // ... inside your Widget build method ...
                TextFormField(
                  controller: empCodeController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter Employee Code";
                    }
                    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
                      return "Only uppercase letters and numbers are allowed";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                    UpperCaseTextFormatter(),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_pin_outlined),
                    hintText: "Employee Code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: ColorConst().blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        onSubmit();
                      }
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Register"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                isLoading
                    ? const Text(
                        "Please wait while registering your face......")
                    : const Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Capture image using front camera and detect faces
  Future<void> _clickImage(BuildContext context) async {
    // Capture an image using the front camera
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front, // Use the front camera
      imageQuality: 70, // Compress the image to reduce size
    );
    print(pickedFile);
    // If an image is selected, proceed to face detection
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });

      // Perform face detection
      _detectFaces(File(_image!.path));
    } else {
      // Optional: Handle the case where no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('No image captured')),
      );
    }
  }

  // Perform face detection on the image
  Future<void> _detectFaces(File imageFile) async {
    // Initialize the face detector
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true, // Enables detection of facial contours
        enableClassification:
            true, // Enables classification of faces (e.g., smiling, eyes open)
      ),
    );

    try {
      // Convert the image file to InputImage
      final inputImage = InputImage.fromFilePath(imageFile.path);

      // Perform face detection
      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        // Case 1: No face detected
        print('No faces detected.');
        setState(() {
          _image = null;
        });
        flutterTts
            .speak("No face detected. Please ensure your face is visible.");
      } else if (faces.length > 1) {
        // Case 2: Multiple faces detected
        setState(() {
          _image = null;
        });
        flutterTts.speak("More than one face detected!");
        print('More than one face detected!');
      } else {
        // Case 3: Single face detected
        final face = faces.first;

        // Check if the face is obstructed or partially visible
        if (face.headEulerAngleY!.abs() > 30 ||
            face.headEulerAngleZ!.abs() > 30) {
          // Large head rotation (looking away from the camera)
          flutterTts.speak("Please face the camera directly.");
          setState(() {
            _image = null;
          });
          print('Face is not facing the camera directly.');
        } else if (face.boundingBox.width < 100 ||
            face.boundingBox.height < 100) {
          // Face is too small (e.g., far from the camera)
          flutterTts.speak("Move closer to the camera.");
          setState(() {
            _image = null;
          });
          print('Face is too small.');
        }
        // else if (face.smilingProbability != null &&
        //     face.smilingProbability! < 0.5) {
        //   // Face is not smiling (optional condition for classification-enabled detectors)
        //   flutterTts.speak("Please smile for the camera.");
        //   print('Face is not smiling.');
        // }
        else if (face.leftEyeOpenProbability != null &&
            face.leftEyeOpenProbability! < 0.5 &&
            face.rightEyeOpenProbability != null &&
            face.rightEyeOpenProbability! < 0.5) {
          // Eyes are closed
          flutterTts.speak("Please open your eyes.");
          setState(() {
            _image = null;
          });
          print('Eyes are closed.');
        } else {
          // Face is properly positioned and unobstructed
          print('Face detected successfully and is well-positioned.');
          flutterTts.speak("Face detected successfully.");
        }
      }
    } catch (e) {
      print('Error detecting faces: $e');
      flutterTts.speak("An error occurred while detecting your face.");
      setState(() {
        _image = null;
      });
    } finally {
      // Close the face detector to release resources
      faceDetector.close();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  onSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (_image == null) {
      flutterTts.speak('Please upload an image to proceed.');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image to proceed.'),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      // Compress and resize image
      File imageFile = File(_image!.path);
      img.Image originalImage = img.decodeImage(await imageFile.readAsBytes())!;
      img.Image resizedImage = img.copyResize(originalImage, width: 800);

      File compressedFile = File(imageFile.path)
        ..writeAsBytesSync(img.encodeJpg(
          resizedImage,
        ));
      // Prepare form data
      FormData formData = FormData.fromMap({
        "uploaded_file": await MultipartFile.fromFile(
          compressedFile.path,
          filename: compressedFile.path.split('/').last,
        ),
        "name": "${firstnameController.text} ${lastnameController.text}",
        "user_id": empCodeController.text,
      });

      // Send the FormData to the API
      Response response = await ApiService().postResponseBody(
        url: "http://34.228.44.206:8000/face_register/",
        reqObj: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // Ensure response.data is a JSON string or Map
          Map<String, dynamic> responseBody;

          if (response.data is String) {
            responseBody = jsonDecode(response.data);
          } else if (response.data is Map<String, dynamic>) {
            responseBody = response.data;
          } else {
            throw Exception("Unexpected response format");
          }

          // Check the 'status' field
          String status = responseBody['Status']?.toString() ?? "unknown";
          String message = responseBody['Message']?.toString() ?? "";
          String errorMessage = responseBody['errorMessage']?.toString() ?? "";

          if (status == "success") {
            // Handle success case
            print("Success: $message");
            flutterTts.speak(message);
            clearForm();
            Navigator.pop(context);
          } else if (status == "error") {
            // Handle error case
            print("Error: $errorMessage");
            if (errorMessage.isNotEmpty) {
              flutterTts.speak(errorMessage); // Speak the error message
            } else {
              flutterTts.speak("An unexpected error occurred."); // Fallback
            }
            setState(() {
              isLoading = false;
            });
          } else {
            throw Exception("Unexpected status value");
          }
        } catch (e) {
          // Log or handle exceptions
          print("An error occurred while parsing the response: $e");
          flutterTts.speak("An unexpected error occurred.");
        }
      } else {
        // Handle non-200/201 status codes
        print("HTTP error: ${response.statusCode}");
        flutterTts.speak("Failed to connect to the server. Please try again.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

// Optional: Method to clear form fields
  void clearForm() {
    firstnameController.clear();
    lastnameController.clear();
    empCodeController.clear();
    setState(() {
      _image = null;
    });
  }
}
