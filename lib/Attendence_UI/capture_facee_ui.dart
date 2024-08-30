import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hrvms_attendence/Attendence_UI/successful_checked_in_user.dart';
import 'package:hrvms_attendence/Utils/images.dart';

class CaptureFaceUI extends StatefulWidget {
  final CameraDescription camera;
  const CaptureFaceUI({super.key, required this.camera});

  @override
  State<CaptureFaceUI> createState() => _CaptureFaceUIState();
}

class _CaptureFaceUIState extends State<CaptureFaceUI> {
  late CameraController controller;
  late Future<void> initializeControllerFuture;
  late FaceDetector faceDetector;
  bool isProcessing = false;
  bool faceDetected = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.max);
    initializeControllerFuture = controller.initialize().then((_) {
      controller.startImageStream(_processCameraImage);
    });
    faceDetector = FaceDetector(
        options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    faceDetector.close();
    super.dispose();
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (isProcessing || faceDetected) return;

    isProcessing = true;
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize =
          Size(image.width.toDouble(), image.height.toDouble());

      const InputImageRotation imageRotation = InputImageRotation.rotation0deg;

      const InputImageFormat inputImageFormat = InputImageFormat.nv21;

      // final planeData = image.planes.map(
      //   (Plane plane) {
      //     return InputImageMetadata(size: size, rotation: rotation, format: format, bytesPerRow: bytesPerRow)
      //     // InputImagePlaneMetadata(
      //     //   bytesPerRow: plane.bytesPerRow,
      //     //   height: plane.height,
      //     //   width: plane.width,
      //     // );
      //   },
      // ).toList();

      final inputImageData = InputImageMetadata(
          size: imageSize,
          rotation: imageRotation,
          format: inputImageFormat,
          bytesPerRow: 5);

      final inputImage =
          InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
      final List<Face> faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        faceDetected = true;
        await controller.stopImageStream();
        final image = await controller.takePicture();
        if (!context.mounted) return;
        // await Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => SuccessfulCheckinUserUI(
        //       imagePath: image.path,
        //     ),
        //   ),
        // );
      }
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<void>(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetImages.logo,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.2,
                    ),
                    const Text(
                      "Capture your face to Check In",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: CameraPreview(controller),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
