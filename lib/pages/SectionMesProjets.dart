import 'package:flutter/material.dart';

class SectionMesProjets extends StatelessWidget {
  final List<Map<String, String>> projets;

  const SectionMesProjets({Key? key, required this.projets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: projets.map((projet) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          elevation: 8,
          shadowColor: Colors.orangeAccent,
          child: ListTile(
            title: Text(projet['titre'] ?? 'Titre'),
            subtitle: Text(projet['description'] ?? 'Description'),
            trailing: Text(projet['statut'] ?? 'Statut'),
          ),
        );
      }).toList(),
    );
  }
}
