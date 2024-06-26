import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hrvms_attendence/Attendence_UI/employee_list_ui.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:hrvms_attendence/Utils/images.dart';

class SuccessfulCheckinUserUI extends StatefulWidget {
  final String imagePath;
  const SuccessfulCheckinUserUI({super.key, required this.imagePath});

  @override
  State<SuccessfulCheckinUserUI> createState() =>
      _SuccessfulCheckinUserUIState();
}

class _SuccessfulCheckinUserUIState extends State<SuccessfulCheckinUserUI> {
   @override
void initState() {
 Timer(Duration(seconds: 2), (){
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> 
 EmployeeListUI()));
});
 super.initState();
}
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
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600),
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
                            child: Image.file(File(widget.imagePath) ,
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

                      },
                      child: const Text(
                        "Home",
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
