import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:hrvms_attendence/Utils/connection_provider.dart';
import 'package:hrvms_attendence/Utils/images.dart';
import 'package:hrvms_attendence/loginUI/bady_model.dart';
import 'package:hrvms_attendence/loginUI/login_ui.dart';
import 'package:hrvms_attendence/registrationUI/register_ui.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool isCheckInEnabled = false;
  String checkVal = '';
  late SharedPreferences prefs;
  bool isSwitchDisabled = false;
  List<String> quotes = [
    "The secret of getting ahead is getting started. – Mark Twain",
    "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
    "Believe you can and you're halfway there. – Theodore Roosevelt",
    "Don't watch the clock; do what it does. Keep going. – Sam Levenson",
    "Act as if what you do makes a difference. It does. – William James",
    "Focus on being productive instead of busy. – Tim Ferriss",
    "Do what you can, with what you have, where you are. – Theodore Roosevelt",
    "Efficiency is doing things right; effectiveness is doing the right things. – Peter Drucker",
    "If you spend too much time thinking about a thing, you’ll never get it done. – Bruce Lee",
    "Small deeds done are better than great deeds planned. – Peter Marshall",
    "Creativity is intelligence having fun. – Albert Einstein",
    "Do one thing every day that scares you. – Eleanor Roosevelt",
    "Innovation distinguishes between a leader and a follower. – Steve Jobs",
    "An idea that is not dangerous is unworthy of being called an idea at all. – Oscar Wilde",
    "Simplicity is the ultimate sophistication. – Leonardo da Vinci"
  ];
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal
  ];
  late Color textColor;
  String currentDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
  String currentQuote = "";
  late Timer _timer;
  List<BadyModel>? badyList = [];
  String? combinedNames;
  List<dynamic> dataList = [];
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
    });
    _changeQuote();
    _timer = Timer.periodic(Duration(hours: 1), (timer) {
      _changeQuote();
    });

    textColor = colors[0];

    // Change text color every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        textColor = (colors..shuffle()).first;
      });
    });
    fetchBadyList();
    super.initState();
  }

  void _changeQuote() {
    final random = Random();
    setState(() {
      currentQuote = quotes[random.nextInt(quotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20),
        //     child: Column(
        //       children: [
        //         Switch(
        //           value: isCheckInEnabled,
        //           onChanged: isSwitchDisabled
        //               ? null
        //               : (value) {
        //                   setState(() {
        //                     isCheckInEnabled = value;
        //                     if (isCheckInEnabled) {
        //                       checkVal =
        //                           prefs.setString('check', 'in').toString();
        //                     } else {
        //                       checkVal =
        //                           prefs.setString('check', 'out').toString();
        //                       isSwitchDisabled =
        //                           true; // Disable switch after toggling to "out"
        //                     }
        //                   });
        //                 },
        //         ),
        //         Text(isCheckInEnabled == true ? "Check In" : "Check Out")
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
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
                    "Face Recoginition Attendance System CheckIn",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    AssetImages.logo,
                    width: constraints.maxWidth * (isTablet ? 0.3 : 0.4),
                    height: constraints.maxWidth * (isTablet ? 0.15 : 0.2),
                  ),
                  const SizedBox(
                    height: 40,
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
                        Center(
                          child: Text(
                            "📅 $currentDate\n💡 Quote of the Day",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold, // Makes text bold
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentQuote,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(height: 20),
                                // const Text(
                                //   "Quote changes every 5 seconds...",
                                //   style: TextStyle(fontSize: 14, color: Colors.grey),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        dataList != null && dataList.isNotEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [
                                        Colors.pink,
                                        Colors.orange,
                                        Colors.yellow
                                      ],
                                    ).createShader(bounds),
                                    child: Text(
                                      "🎉 Happy Birthday $combinedNames 🎂",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.pacifico(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            textColor, // Changing colors dynamically
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox
                                .shrink(), // Hide the widget if dataList is null or empty
                        const SizedBox(height: 20),
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
                                  builder: (context) => const RegistrationUI()),
                            );
                          },
                          child: const Text(
                            "Registration",
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
      ),
    );
  }

  // void _makePhoneCall() async {
  //   const phoneNumber = 'tel:9591081220'; // Replace with any number
  //   if (await canLaunchUrl(Uri.parse(phoneNumber))) {
  //     await launchUrl(Uri.parse(phoneNumber));
  //   } else {
  //     throw 'Could not launch $phoneNumber';
  //   }
  // }

  Future<void> fetchBadyList() async {
    try {
      if (await ConnectionProvider().checkConnectivity()) {
        var url = Uri.parse("http://34.229.118.216:8000/birthdays/");
        var headers = <String, String>{
          "content-type": "application/json",
        };
        final response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          print("Raw Response: ${response.body}");

          try {
            var jsonResponse = jsonDecode(response.body);

            // Ensure jsonResponse is a Map
            if (jsonResponse is Map &&
                jsonResponse.containsKey("birthday_names")) {
              dataList = jsonResponse["birthday_names"];
              setState(() {
                if (dataList.isNotEmpty) {
                  combinedNames = dataList.length > 1
                      ? "${dataList.sublist(0, dataList.length - 1).join(", ")} & " +
                          dataList.last
                      : dataList.first;
                } else {
                  badyList = [];
                }
              });
            } else {
              throw Exception("Unexpected JSON structure: $jsonResponse");
            }
          } catch (e) {
            throw Exception("Error parsing JSON: ${response.body}");
          }
        } else {
          throw Exception(
              "Failed to fetch data. Status: ${response.statusCode}, Response: ${response.body}");
        }
      } else {
        throw Exception("No internet connection.");
      }
    } catch (error) {
      throw Exception("Error fetching data: ${error.toString()}");
    }
  }
}
