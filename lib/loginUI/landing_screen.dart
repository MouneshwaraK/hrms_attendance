import 'package:flutter/material.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:hrvms_attendence/Utils/images.dart';
import 'package:hrvms_attendence/loginUI/login_ui.dart';
import 'package:hrvms_attendence/registrationUI/register_ui.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;

          return Container(
            color: Colors.white,
            width: constraints.maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Face Recoginition Attendance System",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Image.asset(
                  AssetImages.landingScreen,
                  height: constraints.maxWidth * (isTablet ? 0.7 : 0.2),
                ),
                Container(
                  width: constraints.maxWidth * (isTablet ? 0.85 : 0.85),
                  padding: EdgeInsets.all(isTablet ? 40 : 20),
                  decoration: BoxDecoration(
                    color: ColorConst().blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Welcome to CSTECH",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        AssetImages.logo,
                        width: constraints.maxWidth * (isTablet ? 0.3 : 0.4),
                        height: constraints.maxWidth * (isTablet ? 0.15 : 0.2),
                      ),
                      SizedBox(height: isTablet ? 30 : 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 50 : 30,
                            vertical: isTablet ? 20 : 15,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegistrationUI()),
                          );
                        },
                        child: const Text(
                          "Resgistration",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: isTablet ? 20 : 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 50 : 30,
                            vertical: isTablet ? 20 : 15,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginUI()),
                          );
                        },
                        child: const Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
