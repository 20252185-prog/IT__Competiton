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

  // Firebase 콘솔 > 프로젝트 설정 > 내 앱 > 웹 앱 > 구성(Config)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAd3_-OSKt-HCxMHG6p9OQm3klMfFgeLyA',
    appId: '1:647914453636:web:a70d2f821ea5f3bf30e0d1',
    messagingSenderId: '647914453636',
    projectId: 'itapppractice',
    authDomain: 'itapppractice.firebaseapp.com',
  );

  // TODO: Android 로 빌드하기 전에 실제 Android 앱 값으로 교체할 것.
  // 콘솔 > itapppractice > 앱 추가 > Android 등록 후
  // google-services.json 의 mobilesdk_app_id / current_key 를 넣는다.
  // (지금은 웹 값을 임시로 쓰고 있어서 Android 빌드에서는 동작하지 않음)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0ksfErCR9g4o-0gZSszxGrS9YYYCdR04',
    appId: '1:647914453636:android:480e45db4b57a8f730e0d1',
    messagingSenderId: '647914453636',
    projectId: 'itapppractice',
  );
}
