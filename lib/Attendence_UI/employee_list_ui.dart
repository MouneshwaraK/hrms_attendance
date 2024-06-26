import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hrvms_attendence/Attendence_UI/capture_facee_ui.dart';
import 'package:hrvms_attendence/Utils/colors.dart';
import 'package:hrvms_attendence/Utils/images.dart';
import 'package:slider_button/slider_button.dart';

class EmployeeListUI extends StatefulWidget {
  const EmployeeListUI({super.key});

  @override
  State<EmployeeListUI> createState() => _EmployeeListUIState();
}

class _EmployeeListUIState extends State<EmployeeListUI> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  bool isNavigating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AssetImages.logo,
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            SizedBox(  height: MediaQuery.of(context).size.height * 0.01,),
            const Text(
              "Add your attendance here",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
              SizedBox(  height: MediaQuery.of(context).size.height * 0.05,),
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.width * 0.07,
              decoration: BoxDecoration(
                color: ColorConst().blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.white,),
                  suffixIcon: Icon(Icons.keyboard_arrow_down_rounded , color: Colors.white,)
                ),
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.65,
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(color: ColorConst().grey, blurRadius: 2)
                  ]),
              child: 
              //     ListView.builder(
              //       itemCount: items.length,
              //       itemBuilder: (context, index) {
              //         final item = items[index];
              //   return Dismissible(key: Key(item),
              //   onDismissed: (details) async {
              //         if (!isNavigating) {
              //           setState(() {
              //             isNavigating = true;
              //           });
              //           final camera = await availableCameras();
              //           final firstCamera = camera.last;
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => CaptureFaceUI(
              //                       camera: firstCamera,
              //                     )),
              //           ).then((_) {
              //             setState(() {
              //               isNavigating = false;
              //             });
              //           });
              //         }
              //       },
              //    child: Container(
              //         margin:
              //             const EdgeInsets.only(left: 20, right: 20, top: 5),
              //         width: MediaQuery.of(context).size.width * 0.55,
              //         height: MediaQuery.of(context).size.width * 0.07,
              //         padding: const EdgeInsets.only(left: 10, right: 10),
              //         color: Colors.grey.shade100,
              //         child:  Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               item,
              //               style: const TextStyle(
              //                   fontSize: 16, fontWeight: FontWeight.w400),
              //             ),
              //            const Text(
              //               "CST 608",
              //               style: TextStyle(
              //                   fontSize: 16, fontWeight: FontWeight.w400),
              //             )
              //           ],
              //         )),);
            
              // }),
               ListView.builder(itemBuilder: (context, index) {
                return GestureDetector(
                  // onHorizontalDragEnd: (details) async {
                  //   if(details.primaryVelocity != null && details.primaryVelocity! < 0){
                  //     if(!isNavigating) {
                  //       setState(() {
                  //         isNavigating = true;
                  //       });
                  //       final camera = await availableCameras();
                  //       final first
                  //     }
                  //   }
                  // },
                  onTap: () async {
                    final camera = await availableCameras();
                    final firstCamera = camera.last;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CaptureFaceUI(
                                camera: firstCamera,
                              )),
                    );
                  },
                  child: Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 5),
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: MediaQuery.of(context).size.width * 0.07,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      color: Colors.grey.shade100,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rishi kumar",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "CST 608",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          )
                        ],
                      )),
                );
              }),
            ),
            SliderButton(action: () async {
               final camera = await availableCameras();
                    final firstCamera = camera.last;
               Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CaptureFaceUI(
                                camera: firstCamera,
                              )),
                    );
                    return true;
            },
            label: const Text(
          "Swipe to Check In",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17),
        ),
      icon: CircleAvatar(
        radius: 45,
        backgroundColor: ColorConst().blue,
        child: const Icon(Icons.arrow_forward_outlined, size: 35, color: Colors.white,))

            )
          ],
        ),
      ),
    );
  }

  camera() async {}
}
