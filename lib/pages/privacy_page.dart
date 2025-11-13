import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1412),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // 🔥 Zelfde kop als OefeningenPage
                const Text(
                  'FitAI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔒 Titel van de pagina — zelfde layout als OefeningenPage
                const Text(
                  'Privacy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // 👇 Zelfde soort intro als OefeningenPage
                const SizedBox(
                  width: 320,
                  child: Text(
                    'Lees hier hoe FitAI met jouw gegevens omgaat en hoe onze AI werkt achter de schermen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // -------------------------------------------------------
                // GROOT KAART 1 — Wat de AI doet
                // -------------------------------------------------------
                _buildBigCard(
                  title: '🤖 Wat de AI doet',
                  content:
                      'FitAI gebruikt beeldherkenning om te analyseren welke fitnessoefening jij uitvoert. '
                      'De AI kijkt naar vormen, houding en bewegingen in de foto om de oefening te bepalen.\n\n'
                      '✔ De AI herkent GEEN gezichten\n'
                      '✔ De AI zoekt niet naar identiteit\n'
                      '✔ Alleen de beweging en lichaamshouding worden gebruikt\n\n'
                      'De app focust zich dus op jouw oefening, niet op wie jij bent.',
                ),

                const SizedBox(height: 20),

                // -------------------------------------------------------
                // GROOT KAART 2 — Wat er met jouw data gebeurt
                // -------------------------------------------------------
                _buildBigCard(
                  title: '🧠 Wat er met jouw data gebeurt',
                  content:
                      'Foto’s die je maakt blijven standaard alleen op jouw toestel. '
                      'Ze worden niet automatisch verstuurd, opgeslagen of gedeeld.\n\n'
                      '✔ Jij beslist zelf óf iets gedeeld wordt\n'
                      '✔ We slaan geen persoonlijke gegevens op\n'
                      '✔ Geen gezichtsherkenning, geen tracking\n\n'
                      'Als je later vrijwillig toestemming geeft om een foto te uploaden, '
                      'dan wordt die alleen gebruikt om onze AI beter te trainen.\n\n'
                      'Jij behoudt altijd volledige controle over jouw data.',
                ),

                const SizedBox(height: 40),

                // -------------------------------------------------------
                // COMING SOON SECTIE
                // -------------------------------------------------------
                const Text(
                  '🚧 Coming Soon',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                const SizedBox(
                  width: 320,
                  child: Text(
                    'Binnenkort kun je vrijwillig foto’s uploaden om onze AI slimmer te maken. '
                    'Deze functie is optioneel en wordt alleen geactiveerd wanneer jij daar toestemming voor geeft.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Disabled button (zelfde layout als andere knoppen)
                Container(
                  width: 320,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Uploaden (binnenkort beschikbaar)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // GROOT CARD WIDGET — ziet er mooi en belangrijk uit
  // ---------------------------------------------------------
  static Widget _buildBigCard({
    required String title,
    required String content,
  }) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2421),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
