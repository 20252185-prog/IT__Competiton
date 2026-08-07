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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  // 웹 앱 설정값 (Firebase 콘솔 > 프로젝트 설정 > 내 앱 > 웹 앱 > 구성)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAd3_-OSKt-HCxMHG6p9OQm3klMfFgeLyA',
    appId: '1:647914453636:web:a70d2f821ea5f3bf30e0d1',
    messagingSenderId: '647914453636',
    projectId: 'itapppractice',
    authDomain: 'itapppractice.firebaseapp.com',
  );

  // Android 앱 설정값 (android/app/google-services.json 의
  // com.example.it_app 클라이언트 값과 동일)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0ksfErCR9g4o-0gZSszxGrS9YYYCdR04',
    appId: '1:647914453636:android:480e45db4b57a8f730e0d1',
    messagingSenderId: '647914453636',
    projectId: 'itapppractice',
  );
}
