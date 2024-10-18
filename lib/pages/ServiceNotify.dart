import 'dart:convert'; // Import pour jsonEncode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {

  // Fonction pour récupérer un token d'accès depuis Firebase
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      // Authentification sécurisée
        "type": "service_account",
        "project_id": "connectx-653c8",
        "private_key_id": "17ff0eddfd28be5eb6b8e1f4e0d4aa7f1951abe0",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCxebglNVIxfnbe\nYDc2sa9iqppMkNnVqlH9ZbD4TAzVTOxtCoeqmnJXHZ4jgJOW4Lvj/DGYEHEHS3bV\nyipqRLbKlE8WyYkj2fSOkkhCCODYs0FqIttMHncqTnljeVnOtF8aXsRLdN2xrPqc\ntCXpOcmGXKKZSNEf1wYDJN7dXD/YQ0qNNKNER2j+e+0C6iIPnUvxMCNs2tn4blhT\nM9A+AANEQHtncnOGFRY1CXgHwGcapDQhLSGWmPvIqeb3IaQFekqbD+61eVPCUrM7\nPjdt37fWDE4gOx1804M8eagnfxcNQ5p4EGseEM0JmGijlhDEfo24zT91glRrcwlX\nsP45dwwLAgMBAAECggEATDaQkQ3yU4XS5xEbdNXeErlflJS5rws6tV4nnqEN+8VS\nXEsi0m0LwARchjNvbeHpXfDNnVcmKrNJ/2oXR9ZlRt5kjk0Sov40issf05e7cuOb\nqkf4s5n7o4PalhClM+J6Wrkqg5rWnzfA0W19QEgMFjKOstO11n4Au3XobNfyJNyd\nWj8BHqLrzuxanBlu4IQ0aiWt/dPlPukfTNGhRz/W9N0oXGSccx49qnywBCbrdEHK\nI6R67rgQuAwwAECc0PF2VbHp+HC1H6rtSoXn911DVm6ecqHlNdS1ktaRyDHqPXXz\nSwWRRwTLFuogIy/i4AyhA8zRzZRX58zSXpwBWK5YlQKBgQDj8n84Itmi9COUkKrW\nD+UoltW71fC8P8M7CKLFTww1v4QqrQ6TefhjkyDKTTD4VJbE/d9wc2da2/GqtoAE\nCv9HYtg3bL8DNxk9Ns3jugVnVRGfbcWCAqoieSv7wJEJrMPj0hbW+zo2sUEsmlb0\nVc8LNDFyFHFmhikb4AHpDlwp1QKBgQDHURprd0Ky6GtQvgAWWrL6AwrC4kOlKVzo\nV7TsBDIPZWqNP9wIi9XQENkUG769xLC8PP18NGPsGqST9FOWcMZKX52g8xlGM9rI\nfk7yyxZIvQhyNG/eeTY5BWCPiYxi83E9MhOSrzhHp/sdznUS7WjoprY/ps4/2yPN\nwQz/SSJuXwKBgAt3qqDHWA2TnKqfsIh+Wjf1hqEhfS/rQUYaBB5LAME/dkWzWRVg\nQHe58h9bTMhhcQhOAUyl8aAninvdHImXiAouVdRL+zwNLI7gz/DR7e2p4O4VVqdY\nvPhpAiZzJJjJAT3X1uBP2TjhJ/c3eIJoQrc8k/Q6RQ40V6MYXOA9obNVAoGBAJWR\nQ80e+ns8s8MsQO6Fc0bvX3Tsy6w1xNVJc6ekYlhxVyrVn+z92h2/dtaDF3haD/HB\npso8mjsDpzqrnsoGqJYI+EVeBzpKEURgnCfPxFIjICJrPQNqXAkgAtzTb/iVDAXK\n/SsWt5n18Rfl5K6mXxIugBZ1utHqRQzScEllfSPrAoGBAKt4FYaxSpDdpRIL04K8\n+k41RR2BcPQVhqc+6Rlwl+GM3TZ4bb2xBvewIlqmkjMIyeX6EPMosHyB/P4h+QrR\n3l3y3EvI10sWnIM338nddgJFz6MdPdv6OrVwZt+3g+4jEC+TRoOUM5FV+njY7i08\nPSfwAPrACdR7t5kDT2GDm3hW\n-----END PRIVATE KEY-----\n",
        "client_email": "connectx-653c8@appspot.gserviceaccount.com",
        "client_id": "117350467338138317832",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/connectx-653c8%40appspot.gserviceaccount.com",
        "universe_domain": "googleapis.com"

    };

    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/userinfo.email'
    ];

    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close(); // Fermer le client

    return credentials.accessToken.data;
  }

  // Fonction pour envoyer la notification
  static Future<void> sendNotification({
    required String title,
    required String body,
    required String token,
    required String contextType,
    required String contextData,
  }) async {
    final String serverKey = await getAccessToken();
    final String firebaseMessagingEndpoint = 'https://fcm.googleapis.com/v1/projects/connectx-653c8/messages:send';

    final Map<String, dynamic> notificationMessage = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'type': contextType,
          'id': contextData,
        },
      }
    };

    // Convertir en chaîne JSON
    final String bodyJson = jsonEncode(notificationMessage);

    // Envoyer la requête POST avec la chaîne JSON dans le corps
    final response = await http.post(
      Uri.parse(firebaseMessagingEndpoint),
      headers: {
        'Authorization': 'Bearer $serverKey',
        'Content-Type': 'application/json',
      },
      body: bodyJson, // Le corps est maintenant au format JSON
    );

    if (response.statusCode == 200) {
      print('Notification envoyée avec succès.');
    } else {
      print('Erreur lors de l\'envoi de la notification : ${response.body}');
    }
  }
}
