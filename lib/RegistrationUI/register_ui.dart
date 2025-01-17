import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrvms_attendence/RegistrationUI/register_repo.dart';
import 'package:hrvms_attendence/Utils/Api/ApiConst.dart';
import 'package:hrvms_attendence/Utils/Api/api_service.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
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
              TextFormField(
                controller: empCodeController,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Enter Employee Code";
                  }
                  return null;
                },
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
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _clickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  onSubmit() async {
    FormData formData = FormData.fromMap({
      "uploaded_file": await MultipartFile.fromFile(_image!.path,
          filename: _image!.path.split('/').last,
          // contentType: MediaType.parse(getContentType(_image!.path)),
          contentType: MediaType("images", 'jpg')),
      "name": firstnameController.text,
      "user_id": empCodeController.text,
    });
    print(_image!.path);
    // var reqObj = <String, dynamic>{
    //   'name': firstnameController.text,
    //   'user_id': empCodeController.text,
    //   'uploaded_file': MultipartFile.fromFile(_image!.path.toString())
    // };
    var response = await RegisterRepo().registrationPost(formData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A SnackBar has been shown.'),
      ),
    );
  }

  // Define getContentType method inside the class
  String getContentType(String filePath) {
    String fileExtension = filePath.split('.').last.toLowerCase();

    if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      return 'image/jpeg';
    } else if (fileExtension == 'png') {
      return 'image/png';
    } else {
      throw Exception(
          'Invalid file type. Only jpg, jpeg, and png are allowed.');
    }
  }
}
