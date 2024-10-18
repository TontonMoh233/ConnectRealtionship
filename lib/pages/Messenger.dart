import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendMessagePage extends StatelessWidget {
  final String investisseurId;

  SendMessagePage({Key? key, required this.investisseurId}) : super(key: key);

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envoyer un Message"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: "Votre message",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _sendMessage(context);
              },
              child: const Text("Envoyer"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(BuildContext context) async {
    final message = _messageController.text.trim();

    if (message.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'investisseurId': investisseurId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Afficher un message de succès ou retourner à la page précédente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Message envoyé à l'investisseur!")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer un message.")),
      );
    }
  }
}
