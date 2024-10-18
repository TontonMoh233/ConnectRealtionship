import 'package:flutter/material.dart';

class SectionInvestisseursRecommandes extends StatelessWidget {
  final List<Map<String, String>> investisseurs;

  const SectionInvestisseursRecommandes({Key? key, required this.investisseurs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            "Investisseurs Recommandés",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        SizedBox(
          height: 200, // Hauteur de la liste horizontale
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: investisseurs.length,
            itemBuilder: (context, index) {
              final investisseur = investisseurs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                elevation: 8,
                shadowColor: Colors.orangeAccent,
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        investisseur['image'] ?? 'assets/images/avatar.jpg',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          investisseur['nom'] ?? 'Nom Inconnu',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          investisseur['secteur'] ?? 'Secteur Inconnu',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
