import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:hrvms_attendence/Utils/images.dart';

class FailedCheckedInUserUI extends StatefulWidget {
  const FailedCheckedInUserUI({super.key});

  @override
  State<FailedCheckedInUserUI> createState() => _FailedCheckedInUserUIState();
}

class _FailedCheckedInUserUIState extends State<FailedCheckedInUserUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
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
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    Image.asset(
                      AssetImages.failedUser,
                      width: 273,
                      height: 273,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(5)),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white
                        ),
                        onPressed: () {},
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
      ),
    );
  }
}
