// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyArIqeo_1l9gJAoocqn9ogsbduyj2DevpA',
    appId: '1:505205415427:web:e9cc97a94eeb3e9df4b836',
    messagingSenderId: '505205415427',
    projectId: 'connectx-653c8',
    authDomain: 'connectx-653c8.firebaseapp.com',
    storageBucket: 'connectx-653c8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiw4OwUQYI_HV9Wt2nWaqYZd2AyPkYEwU',
    appId: '1:505205415427:android:e69c23b41e6784c2f4b836',
    messagingSenderId: '505205415427',
    projectId: 'connectx-653c8',
    storageBucket: 'connectx-653c8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvKayItm21HYyro0MdHVh6N-7edA6CY_w',
    appId: '1:505205415427:ios:939b55608bdc349bf4b836',
    messagingSenderId: '505205415427',
    projectId: 'connectx-653c8',
    storageBucket: 'connectx-653c8.appspot.com',
    iosBundleId: 'com.relationship.relationship',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAvKayItm21HYyro0MdHVh6N-7edA6CY_w',
    appId: '1:505205415427:ios:939b55608bdc349bf4b836',
    messagingSenderId: '505205415427',
    projectId: 'connectx-653c8',
    storageBucket: 'connectx-653c8.appspot.com',
    iosBundleId: 'com.relationship.relationship',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyArIqeo_1l9gJAoocqn9ogsbduyj2DevpA',
    appId: '1:505205415427:web:c746802ccaf5612df4b836',
    messagingSenderId: '505205415427',
    projectId: 'connectx-653c8',
    authDomain: 'connectx-653c8.firebaseapp.com',
    storageBucket: 'connectx-653c8.appspot.com',
  );
}
