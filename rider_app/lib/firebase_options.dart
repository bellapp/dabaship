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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCjIWa6rNqhFXotaDoHQcvrfRIuY5u5-tk',
    appId: '1:1040326968200:web:8fd20be81ccde142b0b03f',
    messagingSenderId: '1040326968200',
    projectId: 'daba-delivery',
    authDomain: 'daba-delivery.firebaseapp.com',
    storageBucket: 'daba-delivery.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjIWa6rNqhFXotaDoHQcvrfRIuY5u5-tk',
    appId: '1:1040326968200:android:7fd20be81ccde142b0b03e',
    messagingSenderId: '1040326968200',
    projectId: 'daba-delivery',
    authDomain: 'daba-delivery.firebaseapp.com',
    storageBucket: 'daba-delivery.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCjIWa6rNqhFXotaDoHQcvrfRIuY5u5-tk',
    appId: '1:1040326968200:ios:9fd20be81ccde142b0b03g',
    messagingSenderId: '1040326968200',
    projectId: 'daba-delivery',
    authDomain: 'daba-delivery.firebaseapp.com',
    storageBucket: 'daba-delivery.firebasestorage.app',
    iosBundleId: 'com.app.riderApp',
  );
}
