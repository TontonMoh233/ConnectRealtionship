import 'package:flutter/material.dart';
import 'inscription.dart';

class Bienvenuepage extends StatelessWidget {
  const Bienvenuepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "assets/images/Bienvenue.png",
              fit: BoxFit.cover,
            ),
          ),
          // Ici on utilise uniquement Positioned sans Center
          Positioned(
            top: 500, // Place le bouton à partir du haut de l'écran
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50), // Centrer horizontalement
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Inscription()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD9D9D9),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Ajuste la taille interne
                  minimumSize: Size(150, 50), // Définit une taille minimale pour le bouton
                ),
                child: Text(
                  "DEMARRER",
                  style: TextStyle(
                    color: Color(0xFFF30606),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
