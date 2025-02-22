import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentScanPage extends StatefulWidget {
  const DocumentScanPage({super.key});

  @override
  State<DocumentScanPage> createState() => _DocumentScanPageState();
}

class _DocumentScanPageState extends State<DocumentScanPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  double _currentZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.resumed) {
      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() => _isCameraPermissionGranted = false);
        return;
      }
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No cameras found');
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller!.initialize();
      _maxZoomLevel = await _controller!.getMaxZoomLevel();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
        _isCameraPermissionGranted = true;
      });
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      setState(() => _isCameraInitialized = false);
    }
  }

  Widget _buildCameraPreview() {
    if (!_isCameraPermissionGranted) {
      return const Center(
        child: Text(
          'Camera permission denied',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    if (!_isCameraInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return RotatedBox(
      quarterTurns: _controller!.description.sensorOrientation ~/ 90,
      child: CameraPreview(_controller!),
    );
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _controller == null) return;
    try {
      // Show a loading popup to simulate image processing
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.grey[900],
          content: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 20),
                Text(
                  'Processing image...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Take the picture
      final image = await _controller!.takePicture();
      debugPrint('Image path: ${image.path}');

      // Simulate processing delay (e.g., image processing)
      await Future.delayed(const Duration(seconds: 2));

      // Dismiss the loading popup
      Navigator.of(context).pop();

      // Show an information popup
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.grey[900],
          title: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.greenAccent),
              SizedBox(width: 8),
              Text(
                'Done!',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: const Text(
            'Identity Card scanned successfully.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Scan Document',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onScaleUpdate: (details) {
                if (_controller == null || !_controller!.value.isInitialized)
                  return;
                double newZoom = (_currentZoomLevel * details.scale)
                    .clamp(1.0, _maxZoomLevel)
                    .toDouble();
                _controller!.setZoomLevel(newZoom);
                setState(() => _currentZoomLevel = newZoom);
              },
              child: _buildCameraPreview(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
