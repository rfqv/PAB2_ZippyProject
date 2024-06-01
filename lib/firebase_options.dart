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
    apiKey: 'AIzaSyCIHGGwLzWa0EweBnqIIBTXUBhnlFoDznc',
    appId: '1:78604707807:web:81e18e3f40f2bce8d7866a',
    messagingSenderId: '78604707807',
    projectId: 'zippyproject-mrifqiv',
    authDomain: 'zippyproject-mrifqiv.firebaseapp.com',
    storageBucket: 'zippyproject-mrifqiv.appspot.com',
    measurementId: 'G-4GJZBNWYG3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqd6VWx9Q4NrOv05qvPkVAmjuC0zSy-_M',
    appId: '1:78604707807:android:9b8e2e1231d2bb41d7866a',
    messagingSenderId: '78604707807',
    projectId: 'zippyproject-mrifqiv',
    storageBucket: 'zippyproject-mrifqiv.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUDdjMkbV210nkM7rnR8y8gGkU1Js5j8E',
    appId: '1:78604707807:ios:43bc3d9875b4bb84d7866a',
    messagingSenderId: '78604707807',
    projectId: 'zippyproject-mrifqiv',
    storageBucket: 'zippyproject-mrifqiv.appspot.com',
    iosBundleId: 'com.example.zippy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBUDdjMkbV210nkM7rnR8y8gGkU1Js5j8E',
    appId: '1:78604707807:ios:43bc3d9875b4bb84d7866a',
    messagingSenderId: '78604707807',
    projectId: 'zippyproject-mrifqiv',
    storageBucket: 'zippyproject-mrifqiv.appspot.com',
    iosBundleId: 'com.example.zippy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCIHGGwLzWa0EweBnqIIBTXUBhnlFoDznc',
    appId: '1:78604707807:web:bbebebf98fd0b685d7866a',
    messagingSenderId: '78604707807',
    projectId: 'zippyproject-mrifqiv',
    authDomain: 'zippyproject-mrifqiv.firebaseapp.com',
    storageBucket: 'zippyproject-mrifqiv.appspot.com',
    measurementId: 'G-938Z2G91XR',
  );
}
