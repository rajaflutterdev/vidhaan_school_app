import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';


import 'detector_view.dart';
import 'facepainter.dart';
/*
class FaceDetectorView extends StatefulWidget {
  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(

        children: [
          DetectorView(

            title: 'Face Detector',
            customPaint: _customPaint,
            text: _text,
            onImage: _processImage,
            initialCameraLensDirection: _cameraLensDirection,
            onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
            onCameraFeedReady: (){
              print(_text);
              print(_customPaint);
              print(_cameraLensDirection);
              print(_cameraLensDirection.name);
              print(_cameraLensDirection.index);
            },
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("ok"),
        onPressed: (){
          print("Finddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
          print(_text);

          print(_customPaint);
        },
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      final faceData = faces.map((face) {
        return 'Face id: ${face.landmarks}, Confidence: ${face.headEulerAngleX}';
      }).join('\n');
      setState(() {
        _text = text;
      });

      print("SUCESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
      print(text);
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

 */
class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({Key? key}) : super(key: key);

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  @override
  Widget build(BuildContext context) {
    double  height= MediaQuery.of(context).size.height;
    double  width= MediaQuery.of(context).size.width;
     return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Press"),
            onPressed: (){
              func();
            },
          ),
          SizedBox(height: height/15.12,),
          ElevatedButton(
            child: Text("Press2"),
            onPressed: (){
              func2();
            },
          ),
        ],
      ),
    );
  }
  File? _pickedFile2;
  func() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        setState(() {
          _pickedFile2 = File(xFile.path);
        });
      }
    });
    print("fun one completed");
    print(_pickedFile2!.path);

  }
  func2() async {
    print("Fun 2 Starteddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
    final faceDetector = FaceDetector(    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableTracking: true,
    ),);

    // Detect faces in an image.

    final inputImage = InputImage.fromFile(_pickedFile2!);
    final faces = await faceDetector.processImage(inputImage);

    // Get the face data as a string.
    final faceData = faces.map((face) {
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final leftEyePosition = leftEyeLandmark?.position;
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
      final rightEyePosition = rightEyeLandmark?.position;
      final bottommouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];
      final bottommouthPosition = bottommouthLandmark?.position;
      final rightmouthLandmark = face.landmarks[FaceLandmarkType.rightMouth];
      final rightmouthPosition = rightmouthLandmark?.position;
      final leftmouthLandmark = face.landmarks[FaceLandmarkType.leftMouth];
      final leftmouthPosition = leftmouthLandmark?.position;
      final nouseLandmark = face.landmarks[FaceLandmarkType.noseBase];
      final nousePosition = nouseLandmark?.position;

      return 'Face id: ${leftEyePosition!.x},${rightEyePosition!.x},${bottommouthPosition!.x},${rightmouthPosition!.x},${leftmouthPosition!.x},${nousePosition!.x},';
    }).join('\n');
    final faceData2 = faces.map((face) async {
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final leftEyePosition = leftEyeLandmark?.position;
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
      final rightEyePosition = rightEyeLandmark?.position;
      final bottommouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];
      final bottommouthPosition = bottommouthLandmark?.position;
      final rightmouthLandmark = face.landmarks[FaceLandmarkType.rightMouth];
      final rightmouthPosition = rightmouthLandmark?.position;
      final leftmouthLandmark = face.landmarks[FaceLandmarkType.leftMouth];
      final leftmouthPosition = leftmouthLandmark?.position;
      final nouseLandmark = face.landmarks[FaceLandmarkType.noseBase];
      final nousePosition = nouseLandmark?.position;
      /*FirebaseFirestore.instance.collection("FACEID").doc("JOHN").set({
        "leftEyePositionx":leftEyePosition!.x,
        "rightEyePositionx":rightEyePosition!.x,
        "bottommouthPositionx":bottommouthPosition!.x,
        "rightmouthPositionx":rightmouthPosition!.x,
        "leftmouthPositionx":leftmouthPosition!.x,
        "nousePositionx":nousePosition!.x,
        "leftEyePositiony":leftEyePosition!.y,
        "rightEyePositiony":rightEyePosition!.y,
        "bottommouthPositiony":bottommouthPosition!.y,
        "rightmouthPositiony":rightmouthPosition!.y,
        "leftmouthPositiony":leftmouthPosition!.y,
        "nousePositiony":nousePosition!.y,
      });

       */
      var documet = await FirebaseFirestore.instance.collection("FACEID").doc("Raja").get();
      Map<String, dynamic>?  value= documet.data();
      int i =0;
      setState(() {
        i=0;
      });
      if(value!["leftEyePositionx"]<=leftEyePosition!.x+100&&value!["leftEyePositionx"]>=leftEyePosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["rightEyePositionx"]<=rightEyePosition!.x+100&&value!["rightEyePositionx"]>=rightEyePosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["bottommouthPositionx"]<=bottommouthPosition!.x+100&&value!["bottommouthPositionx"]>=bottommouthPosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["rightmouthPositionx"]<=rightmouthPosition!.x+100&&value!["rightmouthPositionx"]>=rightmouthPosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["leftmouthPositionx"]<=leftmouthPosition!.x+100&&value!["leftmouthPositionx"]>=leftmouthPosition!.x-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["nousePositionx"]<=nousePosition!.x+100&&value!["nousePositionx"]>=nousePosition!.x-100){
        setState(() {
          i=i+1;
        });
      }

      if(value!["leftEyePositiony"]<=leftEyePosition!.y+100&&value!["leftEyePositiony"]>=leftEyePosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["rightEyePositiony"]<=rightEyePosition!.y+100&&value!["rightEyePositiony"]>=rightEyePosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["bottommouthPositiony"]<=bottommouthPosition!.y+100&&value!["bottommouthPositiony"]>=bottommouthPosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["rightmouthPositiony"]<=rightmouthPosition!.y+100&&value!["rightmouthPositiony"]>=rightmouthPosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["leftmouthPositiony"]<=leftmouthPosition!.y+100&&value!["leftmouthPositiony"]>=leftmouthPosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(value!["nousePositiony"]<=nousePosition!.y+100&&value!["nousePositiony"]>=nousePosition!.y-100){
        setState(() {
          i=i+1;
        });
      }
      if(i==12){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("FACE VVerified")));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("FACE Not Verified")));
      }

      print("Fun 4574567456745674");
      return 'Face id: ${leftEyePosition!.y},${rightEyePosition!.y},${bottommouthPosition!.y},${rightmouthPosition!.y},${leftmouthPosition!.y},${nousePosition!.y},';
    }).join('\n');

    // Print the face data.
    print(faceData);
    print(faceData2);

    print("Fun 2 Completedddddddddddddddddddddddddddddddddddddddddddddd");

  }
  checkface() async {

  }

}
