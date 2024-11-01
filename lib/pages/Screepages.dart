import 'package:flutter/material.dart';
import 'Accueil.dart';
import 'SwipesPages.dart'; // Remplacez par le nom de la page vers laquelle vous voulez rediriger.

class SplashScreenpages extends StatelessWidget {
  const SplashScreenpages({super.key});

  @override
  Widget build(BuildContext context) {
    // Crée un délai de 3 secondes avant de rediriger vers la page suivante.
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomPages()), // Remplacez `Accueil()` par la page cible.
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/img.png'), // Remplacez par le chemin de votre logo.
      ),
    );
  }
}
