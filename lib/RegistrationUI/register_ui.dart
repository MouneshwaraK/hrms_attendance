import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
                    child: _image == null
                        ? const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          )
                        : ClipOval(
                            child: Image.file(
                              File(_image!.path),
                              fit: BoxFit.cover,
                              width: screenWidth * 0.3,
                              height: screenWidth * 0.3,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: firstnameController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter First Name";
                    }
                    return null;
                  },
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

  Future<void> _clickImage(BuildContext context) async {
    final picker = ImagePicker();

    // Capture an image using the front camera
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front, // Use the front camera
      imageQuality: 70, // Compress the image to reduce size
    );

    // If an image is selected, update the state
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    } else {
      // Optional: Handle the case where no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('No image captured')),
      );
    }
  }

  onSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (_image == null) {
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

          // Safely extract the 'info' key
          String successInfo =
              responseBody['info']?.toString() ?? "Unknown success message";

          // Print and use the success info
          print("Success: $successInfo");
          flutterTts.speak("Registration successfully Done.");
          clearForm();
          Navigator.pop(context);
        } catch (e) {
          // Log or handle exceptions
          print("An error occurred while parsing the response: $e");
          flutterTts.speak("An unexpected error occurred.");
        }
      } else {
        // Handle other response codes
        flutterTts.speak("Sorry, something went wrong. Please try again.");
        print("Error: ${response.statusCode} - ${response.statusMessage}");
        setState(() {
          isLoading = false;
        });
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
