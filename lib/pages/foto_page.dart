import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ai_fitness_app/services/ai_service.dart';
import 'package:ai_fitness_app/pages/resultaat_page.dart';

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
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();

    if (!mounted) return;
    setState(() => _isCameraInitialized = true);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // 📸 FOTO MAKEN MET CAMERA
  Future<void> _takePicture() async {
    try {
      final picture = await _cameraController!.takePicture();
      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => _buildPhotoPreview(context, picture.path),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fout bij foto maken: $e')));
    }
  }

  // 🖼 FOTO UPLOADEN UIT GALERIJ
  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildPhotoPreview(context, picked.path),
    );
  }

  // 📸 PREVIEW POP-UP
  Widget _buildPhotoPreview(BuildContext context, String imagePath) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Color(0xFF141E1B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Foto Preview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ✔ BEVESTIGEN KNOP
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 35),
            child: ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context); // sluit preview popup

                final ai = AIService();
                await ai.loadModel();

                final result = await ai.predict(imagePath);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultaatPage(
                      exerciseName: result["label"],
                      confidence: result["confidence"],
                      imageAssetPath: "assets/images/${result["label"]}.png",
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Bevestigen',
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
          ),
        ],
      ),
    );
  }

  // 📱 HOOFDPAGINA UI
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

                // CAMERA PREVIEW
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(_cameraController!),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 📸 BUTTON — FOTO MAKEN
                ElevatedButton.icon(
                  onPressed: _takePicture,
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

                const SizedBox(height: 12),

                // 🖼 BUTTON — FOTO UPLOADEN
                ElevatedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo, color: Colors.white),
                  label: const Text(
                    'Upload foto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C7E5C),
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
