import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();

  // 👇 Hier kun je makkelijk je eigen afbeeldingen en teksten toevoegen
  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/homeslide1.png',
      'text':
          '“Weet je niet zeker of je je oefening goed uitvoert?”\nJe bent niet de enige.',
    },
    {
      'image': 'assets/images/homeslide2.png',
      'text':
          '“AI helpt je je houding te verbeteren en blessures te voorkomen.”',
    },
    {
      'image': 'assets/images/homeslide3.png',
      'text': '“Begin vandaag nog met het analyseren van je training.”',
    },
    {
      'image': 'assets/images/homeslide4.png',
      'text': '“Begin vandaag nog met het analyseren van je training.”',
    },
    {
      'image': 'assets/images/homeslide5.png',
      'text': '“Begin vandaag nog met het analyseren van je training.”',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1412), // Donkere achtergrond
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // bovenaan beginnen
            crossAxisAlignment:
                CrossAxisAlignment.center, // horizontaal centreren
            children: [
              const SizedBox(height: 40),
              const Text(
                'FitAI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welkom bij FitAI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '“Weet je niet zeker of je je oefening goed uitvoert?”\nJe bent niet de enige.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              // 👇 De carrousel slider
              SizedBox(
                height: 450,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Afbeelding
                        Container(
                          width: 280,
                          height: 375,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFF7BA17B), // placeholderkleur
                            image: DecorationImage(
                              image: AssetImage(slide['image']!),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tekst onder afbeelding
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            slide['text']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 👇 Puntjes onderaan
              SmoothPageIndicator(
                controller: _controller,
                count: _slides.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.white24,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
