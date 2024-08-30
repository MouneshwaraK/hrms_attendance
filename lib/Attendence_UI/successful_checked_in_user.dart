import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hrvms_attendence/Attendence_UI/capture_facee_ui.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:hrvms_attendence/Utils/images.dart';

class SuccessfulCheckinUserUI extends StatefulWidget {
  final String imagePath; // Declare imagePath as a required parameter

  const SuccessfulCheckinUserUI({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<SuccessfulCheckinUserUI> createState() =>
      _SuccessfulCheckinUserUIState();
}

class _SuccessfulCheckinUserUIState extends State<SuccessfulCheckinUserUI> {
  @override
  void initState() {
    super.initState();
  }

  late final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
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
                              File(widget.imagePath),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.width * 0.3,
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CaptureFaceUI(
                              camera: camera,
                            ),
                          ),
                        );
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
    );
  }
}
