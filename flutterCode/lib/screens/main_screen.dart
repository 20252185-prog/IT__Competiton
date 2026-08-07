import 'package:flutter/material.dart';
import '../constants/colors.dart';

import 'housing_tab.dart';
import 'assets_tab.dart';
import 'employment_tab.dart';
import 'more_tab.dart';
import 'chatbot_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 하단 탭 순서: 0-주거, 1-자산, 2-취업, 3-더보기
  final List<Widget> _pages = const [
    HousingTab(),
    AssetsTab(),
    EmploymentTab(),
    MoreTab(),
  ];

  // 챗봇 버튼을 누르면 화면 하단에서 올라오는 시트로 챗봇을 띄운다.
  void _openChatbot() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: ChatbotScreen(
            onClose: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openChatbot,
        backgroundColor: const Color(0xFF1E4276),
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(
          Icons.chat_bubble_outline_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E4276),
        unselectedItemColor: kMutedFg,
        backgroundColor: kCard,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '주거',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_outlined),
            activeIcon: Icon(Icons.savings),
            label: '자산',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: '취업',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: '더보기',
          ),
        ],
      ),
    );
  }
}