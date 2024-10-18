import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:relationship/pages/Accueil.dart';
import 'package:relationship/pages/AccueilEntrepreneur.dart';
import 'package:relationship/pages/AdminDashboard.dart';
import 'package:relationship/pages/AjouterUnProjet.dart';
import 'package:relationship/pages/BienvenuePage.dart';
import 'package:relationship/pages/DetailsDuProjet.dart';
import 'package:relationship/pages/IdeeDeProjet.dart';
import 'package:relationship/pages/InvestisseurProjet.dart';
import 'package:relationship/pages/ManagementUtilisateurs.dart';
import 'package:relationship/pages/ModiferProfilEntrepreneur.dart';
import 'package:relationship/pages/NotificationPages.dart';
import 'package:relationship/pages/PartProjet.dart';
import 'package:relationship/pages/Profil.dart';
import 'package:relationship/pages/ProjetEnCour.dart';
import 'package:relationship/pages/SwipesPages.dart';
import 'package:relationship/pages/connexion.dart';
import 'package:relationship/pages/inscription.dart';
import 'package:relationship/pages/connexion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:relationship/pages/rechercherInvestisseur.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Gérer les messages reçus lorsque l'application est en arrière-plan
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // ID unique
  'High Importance Notifications', // Nom visible
  description: 'Ce canal est utilisé pour les notifications importantes.',
  importance: Importance.max,
);

void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Créer le canal pour Android
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}
void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging. requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    sound: true,
  );

  if(settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Autorisation accordée');
  } else {
    print('Autorisation refusée');
  }
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  initializeNotifications();
  requestPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });



  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home:InvestorDashboard()
    );
  }
}
