import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FotoPage extends StatefulWidget {
  const FotoPage({super.key});

  @override
  State<FotoPage> createState() => _FotoPageState();
}

class _FotoPageState extends State<FotoPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // verkrijg alle beschikbare camera's
    final cameras = await availableCameras();

    // selecteer de voorcamera
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();

    if (!mounted) return;

    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1412),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141E1B),
        title: const Text('Camera oefening'),
        centerTitle: true,
      ),
      body: _isCameraInitialized
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // uitlegtekst
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Zorg dat je volledig in beeld bent voordat je de foto maakt.\nGebruik de voorcamera voor een juiste houding.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // camera-preview
                AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CameraPreview(_cameraController!),
                  ),
                ),

                const SizedBox(height: 30),

                // knop om foto te nemen
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final picture = await _cameraController!.takePicture();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Foto opgeslagen: ${picture.path}'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fout bij foto maken: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text(
                    'Neem foto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7BA17B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
