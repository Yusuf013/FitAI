import 'package:flutter/material.dart';

class ResultaatPage extends StatelessWidget {
  final String exerciseName;
  final String imageAssetPath;
  final double confidence;

  const ResultaatPage({
    super.key,
    required this.exerciseName,
    required this.imageAssetPath,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1512),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔙 Back button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Titel
                const Text(
                  "FitAI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "de oefening die je deed is\nhoogstwaarschijnlijk:",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFB3C2BB), fontSize: 14),
                ),

                const SizedBox(height: 10),

                // OEFENING TITEL
                Text(
                  exerciseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                // ✔ Confidence tonen
                Text(
                  "Betrouwbaarheid: ${(confidence * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 25),

                // Oefening afbeelding
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B3A35),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    imageAssetPath,
                    height: 280,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Uitvoering",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 20),

                _instructionBlock("1. Stel de kabels in", const [
                  "Zet de pulleys op schouderhoogte of iets daarboven.",
                  "Bevestig handgrepen aan beide kabels.",
                ]),

                const SizedBox(height: 10),

                _instructionBlock("2. Startpositie", const [
                  "Ga in het midden staan met lichte spanning op de kabels.",
                  "Hou een rechte houding vast.",
                ]),

                const SizedBox(height: 10),

                _instructionBlock("3. Uitvoering", const [
                  "Breng je handen voor je borst met een lichte buiging in je ellebogen.",
                  "Beweeg gecontroleerd terug naar startpositie.",
                ]),

                const SizedBox(height: 30),

                // Opslaan-knop
                _actionButton(
                  icon: Icons.bookmark,
                  label: "oefening opslaan",
                  onPressed: () {},
                ),

                const SizedBox(height: 16),

                // Deel-knop
                _actionButton(
                  icon: Icons.share,
                  label: "oefening delen",
                  onPressed: () {},
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------- COMPONENTS -------

  Widget _instructionBlock(String title, List<String> bullets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFB6EB8E),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        ...bullets.map(
          (b) => Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "• ",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Expanded(
                  child: Text(
                    b,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2B3A35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
