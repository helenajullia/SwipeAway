import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    } else {
      throw UnsupportedError('Platform not supported.');
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUQhdEFWHJTCw-Jf_m_9OMW5GDPZ4CNBc',
    appId: '1:477050565556:ios:46d5dd19bcd343cde678e1',
    messagingSenderId: '477050565556',
    projectId: 'swipeaway-7195c',
    databaseURL: 'https://swipeaway-7195c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'swipeaway-7195c.appspot.com',
    iosClientId: '477050565556-amuasu804m4nlq7vua24kj5udmlgl6k9.apps.googleusercontent.com',
    iosBundleId: 'com.helena.swipeAway2',
  );

}
// const firebaseOptions = FirebaseOptions(
//   apiKey: 'AIzaSyD789YE1SljrK7LDDuRBKJexpShTwUiDFE',
//   authDomain: 'swipeaway-7195c.firebaseapp.com',
//   projectId: 'swipeaway-7195c',
//   storageBucket: 'YOUR_STORAGE_BUCKET',
//   messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
//   appId: '1:477050565556:android:f76ea1429c022b7ee678e1',
// );