import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: "AIzaSyAXaTW6d-n_fZY6xPWSnHsYNTCgvu4btVc",
    authDomain: "echo-quiz-edef4.firebaseapp.com",
    projectId: "echo-quiz-edef4",
    storageBucket: "echo-quiz-edef4.firebasestorage.app",
    messagingSenderId: "166528374954",
    appId: "1:166528374954:web:82bb9158bd8509cf6a98d3",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAXaTW6d-n_fZY6xPWSnHsYNTCgvu4btVc",
    authDomain: "echo-quiz-edef4.firebaseapp.com",
    projectId: "echo-quiz-edef4",
    storageBucket: "echo-quiz-edef4.firebasestorage.app",
    messagingSenderId: "166528374954",
    appId: "1:166528374954:web:82bb9158bd8509cf6a98d3",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAXaTW6d-n_fZY6xPWSnHsYNTCgvu4btVc",
    authDomain: "echo-quiz-edef4.firebaseapp.com",
    projectId: "echo-quiz-edef4",
    storageBucket: "echo-quiz-edef4.firebasestorage.app",
    messagingSenderId: "166528374954",
    appId: "1:166528374954:web:82bb9158bd8509cf6a98d3",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyAXaTW6d-n_fZY6xPWSnHsYNTCgvu4btVc",
    authDomain: "echo-quiz-edef4.firebaseapp.com",
    projectId: "echo-quiz-edef4",
    storageBucket: "echo-quiz-edef4.firebasestorage.app",
    messagingSenderId: "166528374954",
    appId: "1:166528374954:web:82bb9158bd8509cf6a98d3",
  );
}
