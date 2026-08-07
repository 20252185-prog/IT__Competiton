import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants/colors.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 설정이 아직 없거나 지원되지 않는 플랫폼(웹 등)에서도
  // 앱 화면은 정상적으로 뜨도록 초기화 실패를 흡수한다.
  // 챗봇 기능만 비활성화되고 나머지 탭은 그대로 동작한다.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, s) {
    debugPrint('⚠️ Firebase 초기화 실패 (챗봇 기능 비활성화): $e');
    debugPrintStack(stackTrace: s);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '걸어서 사회 속으로',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: kBackground,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        useMaterial3: true,
      ),
      // Scaffold로 감싸서 Material 위젯 에러 방지 및 전체 화면 출력
      home: const Scaffold(
        body: MainScreen(),
      ),
    );
  }
}