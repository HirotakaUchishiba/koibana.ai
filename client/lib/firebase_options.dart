// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCDEThZZZyGq-8xtu0luxpUtQzfPnip0L4',
    appId: '1:338461090687:web:52bcebc385fbd366b7b04a',
    messagingSenderId: '338461090687',
    projectId: 'koibana-ai-c9ac1',
    authDomain: 'koibana-ai-c9ac1.firebaseapp.com',
    storageBucket: 'koibana-ai-c9ac1.appspot.com',
    measurementId: 'G-8679YSS75J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCttHvFkx3pIjo8nqV84EWGuMLihhM3dz0',
    appId: '1:338461090687:android:eed48e35b2a516f8b7b04a',
    messagingSenderId: '338461090687',
    projectId: 'koibana-ai-c9ac1',
    storageBucket: 'koibana-ai-c9ac1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVMvwhey1U3XzK_FqkGMFxuq86wQfEaB0',
    appId: '1:338461090687:ios:191867e13f41ad40b7b04a',
    messagingSenderId: '338461090687',
    projectId: 'koibana-ai-c9ac1',
    storageBucket: 'koibana-ai-c9ac1.appspot.com',
    iosClientId: '338461090687-gvsl7ada9q3ognjq3q6ld692nc4unqkc.apps.googleusercontent.com',
    iosBundleId: 'com.example.client',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVMvwhey1U3XzK_FqkGMFxuq86wQfEaB0',
    appId: '1:338461090687:ios:191867e13f41ad40b7b04a',
    messagingSenderId: '338461090687',
    projectId: 'koibana-ai-c9ac1',
    storageBucket: 'koibana-ai-c9ac1.appspot.com',
    iosClientId: '338461090687-gvsl7ada9q3ognjq3q6ld692nc4unqkc.apps.googleusercontent.com',
    iosBundleId: 'com.example.client',
  );
}
