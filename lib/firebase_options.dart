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
    apiKey: 'AIzaSyDkp0Pyc7Ef36ac8M3gKp8uYGZlhg4o8GI',
    appId: '1:173453066921:web:65a55efed39f5900491fb8',
    messagingSenderId: '173453066921',
    projectId: 'fruitsmart-2a32d',
    authDomain: 'fruitsmart-2a32d.firebaseapp.com',
    storageBucket: 'fruitsmart-2a32d.firebasestorage.app',
    measurementId: 'G-E1HGPV2RNY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHba2QfJeljNEr_mw_8SOJpVJk8NeXI4k',
    appId: '1:173453066921:android:34abc4e8b67f1f2f491fb8',
    messagingSenderId: '173453066921',
    projectId: 'fruitsmart-2a32d',
    storageBucket: 'fruitsmart-2a32d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnhc6dmPpegb1tcDMfHxYoEl8JUlqUzKA',
    appId: '1:173453066921:ios:7a7848de836dfdee491fb8',
    messagingSenderId: '173453066921',
    projectId: 'fruitsmart-2a32d',
    storageBucket: 'fruitsmart-2a32d.firebasestorage.app',
    iosBundleId: 'com.heavoice.cihuy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnhc6dmPpegb1tcDMfHxYoEl8JUlqUzKA',
    appId: '1:173453066921:ios:7a7848de836dfdee491fb8',
    messagingSenderId: '173453066921',
    projectId: 'fruitsmart-2a32d',
    storageBucket: 'fruitsmart-2a32d.firebasestorage.app',
    iosBundleId: 'com.heavoice.cihuy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDkp0Pyc7Ef36ac8M3gKp8uYGZlhg4o8GI',
    appId: '1:173453066921:web:595a8838b8f90b96491fb8',
    messagingSenderId: '173453066921',
    projectId: 'fruitsmart-2a32d',
    authDomain: 'fruitsmart-2a32d.firebaseapp.com',
    storageBucket: 'fruitsmart-2a32d.firebasestorage.app',
    measurementId: 'G-RZJWKYY2W0',
  );
}
