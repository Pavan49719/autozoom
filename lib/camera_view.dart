import 'dart:io';
import 'package:autozoom/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

CameraController? _controller;
Size screenSize = WidgetsBinding.instance.window.physicalSize;
double newZoomLevel = 1.0;
double screenWidth = screenSize.width;
double screenHeight = screenSize.height;
double maxZoom = 10;
double perc = 0.0;

void autoZoom(double imageWidth, double imageHeight, double regionWidth,
    double regionHeight) async {
  maxZoom = await _controller!.getMaxZoomLevel();
  if ((regionWidth + screenWidth * 0.20) < screenWidth) {
    newZoomLevel += 0.3;
    newZoomLevel = newZoomLevel > maxZoom ? maxZoom : newZoomLevel;
    _controller!.setZoomLevel(newZoomLevel);
    perc = newZoomLevel / maxZoom * 100;
  } else if ((regionWidth) > screenWidth + screenWidth * 0.30) {
    newZoomLevel -= 0.3;
    newZoomLevel = newZoomLevel > maxZoom ? maxZoom : newZoomLevel;
    _controller!.setZoomLevel(newZoomLevel);

    perc = newZoomLevel / maxZoom * 100;
  }
}

//Below function aslo does the same task in a faster way than above function.
//But below functin is less accurate for nearer objects.

// void autoZoomToRegion(double imageHeight, double imageWidth, double regionWidth,
//     double regionHeight) async {
//   if (regionWidth < screenWidth) {
//     // Calculate the scale factor to fit the image within the screen
//     double imageAspectRatio = imageWidth / imageHeight;
//     double screenAspectRatio = screenWidth / screenHeight;
//     double scaleFactor = 1.0;
//     if (imageAspectRatio > screenAspectRatio) {
//       scaleFactor = screenWidth / imageWidth;
//     } else {
//       scaleFactor = screenHeight / imageHeight;
//     }

//     // Calculate the size and position of the region within the screen
//     double regionWidthScaled = regionWidth * scaleFactor;
//     double regionHeightScaled = regionHeight * scaleFactor;

//     // Calculate the zoom level needed to fill the region within the screen
//     double zoomLevel = 1.0;
//     if (regionWidthScaled > regionHeightScaled) {
//       zoomLevel = (screenWidth - regionWidthScaled) / screenWidth;
//     } else {
//       zoomLevel = (screenHeight - regionHeightScaled) / screenHeight;
//     }

//     // Adjust the zoom level to fit within the camera's zoom range
//     double maxZoom = await _controller!.getMaxZoomLevel();
//     double minZoom = await _controller!.getMinZoomLevel();
//     double newZoom = (maxZoom - minZoom) * zoomLevel + minZoom;
//     // print("NEWZOOMLEVEL before: $zoomLevel");
//     newZoom = newZoom.clamp(minZoom, maxZoom);
//     // Set the zoom level of the camera
//     newZoom = newZoom > zoomLevelBefore ? newZoom : zoomLevelBefore;
//     zoomLevelBefore = newZoom;
//     print("NEWZOOMLEVEL after: $newZoom");
//     _controller!.setZoomLevel(newZoom);
//   }
// }

class CameraView extends StatefulWidget {
  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  const CameraView({
    Key? key,
    required this.title,
    required this.onImage,
    required this.initialDirection,
    this.customPaint,
    this.text,
  }) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  int _cameraIndex = 0;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  bool _chagingCameraLens = false;

  @override
  void initState() {
    super.initState();

    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 99,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
          (element) =>
              element.lensDirection == widget.initialDirection &&
              element.sensorOrientation == 99,
        ),
      );
    } else {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
            (element) => element.lensDirection == widget.initialDirection),
      );
    }
    _startLive();
  }

  Future _startLive() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _processCameraImage(final CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;
    final planeData = image.planes.map((final Plane plane) {
      return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width);
    }).toList();
    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );
    widget.onImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zoom: ${perc.round()} %"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _controller!.setZoomLevel(1.0);
              newZoomLevel = 1.0;
              perc = 0.0;
            },
            icon: const Icon(Icons.restore_rounded),
          ),
        ],
      ),
      body: _liveBody(),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget? _floatingActionButton() {
    if (cameras.length == 1) return null;

    return SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        onPressed: _switchCamera,
        child: Icon(
          Platform.isIOS
              ? Icons.flip_camera_ios_outlined
              : Icons.flip_camera_android_rounded,
          size: 40,
        ),
      ),
    );
  }

  Future _switchCamera() async {
    setState(() {
      newZoomLevel = 1.0;
      _chagingCameraLens = true;
    });
    _cameraIndex = (_cameraIndex + 1) % cameras.length;
    await _startLive();
    setState(() {
      _chagingCameraLens = false;
    });
  }

  Widget _liveBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: scale,
            child: Center(
              child: _chagingCameraLens
                  ? const Center(
                      child: Text("Changing camera lens"),
                    )
                  : CameraPreview(_controller!),
            ),
          ),
          if (widget.customPaint != null) widget.customPaint!,
        ],
      ),
    );
  }
}
