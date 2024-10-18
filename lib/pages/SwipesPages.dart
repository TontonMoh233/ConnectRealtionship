import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LiquidSwipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pages = [
      // Écran pour les entrepreneurs
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF004D40), // Vert foncé
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/Animation.json',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 20),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Développez votre entreprise avec nous',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  speed: Duration(milliseconds: 100),
                ),
                RotateAnimatedText(
                  'Boostez votre croissance',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                  duration: Duration(milliseconds: 1000),
                ),
                ScaleAnimatedText(
                  'Atteignez de nouveaux sommets',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 1000),
            ),
            SizedBox(height: 10),
            AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                  'Trouvez des investisseurs et des mentors pour accélérer votre croissance.',
                  textStyle: TextStyle(fontSize: 18, color: Colors.white70),
                  duration: Duration(milliseconds: 2000),
                ),
                ColorizeAnimatedText(
                  'Votre succès commence ici.',
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  colors: [
                    Colors.blue,
                    Colors.purple,
                    Colors.yellow,
                    Colors.red,
                  ],
                  speed: Duration(milliseconds: 300),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 500),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      // Écran pour les investisseurs
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF3E2723), // Marron foncé
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/investor.json',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 20),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Investissez dans les projets de demain',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  speed: Duration(milliseconds: 100),
                ),
                RotateAnimatedText(
                  'Soutenez l’innovation',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  duration: Duration(milliseconds: 1000),
                ),
                ScaleAnimatedText(
                  'Réalisez des profits intelligents',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 1000),
            ),
            SizedBox(height: 10),
            AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                  'Soutenez les entrepreneurs innovants pour bâtir un futur meilleur.',
                  textStyle: TextStyle(fontSize: 18, color: Colors.white70),
                  duration: Duration(milliseconds: 2000),
                ),
                ColorizeAnimatedText(
                  'Le futur vous appartient.',
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  colors: [
                    Colors.blue,
                    Colors.purple,
                    Colors.yellow,
                    Colors.red,
                  ],
                  speed: Duration(milliseconds: 300),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 500),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      // Écran pour les mentors
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF1B5E20), // Vert foncé
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/mentor.json',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 20),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Partagez votre expérience avec les jeunes talents',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  speed: Duration(milliseconds: 100),
                ),
                RotateAnimatedText(
                  'Formez les leaders de demain',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen,
                  ),
                  duration: Duration(milliseconds: 1000),
                ),
                ScaleAnimatedText(
                  'Inspirez le changement',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 1000),
            ),
            SizedBox(height: 10),
            AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                  'Accompagnez les entrepreneurs dans leur parcours de réussite.',
                  textStyle: TextStyle(fontSize: 18, color: Colors.white70),
                  duration: Duration(milliseconds: 2000),
                ),
                ColorizeAnimatedText(
                  'Votre savoir, leur avenir.',
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  colors: [
                    Colors.blue,
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                  ],
                  speed: Duration(milliseconds: 300),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 500),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: LiquidSwipe(
        pages: pages,
        fullTransitionValue: 300,
        waveType: WaveType.liquidReveal,
        enableLoop: true,
        slideIconWidget: Icon(Icons.arrow_back_ios, color: Colors.white),
        positionSlideIcon: 0.8,
        onPageChangeCallback: (page) {
          print('Page actuelle: $page');
        },
      ),
    );
  }
}
