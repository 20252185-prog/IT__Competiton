import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants/colors.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '사회초년생 가이드',
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