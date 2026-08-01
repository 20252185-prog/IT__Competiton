import 'package:flutter/material.dart';
import '../constants/colors.dart';

// 📁 개별 탭 및 화면 파일 불러오기
import 'housing_tab.dart';     // 🏠 주거 (기본용어, 체크리스트, 트러블슈팅, 계약서팁)
import 'assets_tab.dart';      // 💰 자산 (청약가이드, 정부지원금)
import 'employment_tab.dart';  // 💼 취업 (근로계약서, 구직사이트)
import 'more_tab.dart';        // 💬 더보기 (비상연락처 등)
import 'chatbot_screen.dart';  // 🤖 AI 챗봇

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 0: 주거, 1: 자산, 2: 취업, 3: 더보기
  int _selectedIndex = 0;

  // 💡 정식 탭 화면 연결 (순서: 0-주거, 1-자산, 2-취업, 3-더보기)
  final List<Widget> _pages = const [
    HousingTab(),
    AssetsTab(),
    EmploymentTab(),
    MoreTab(),
  ];

  // 💬 하단 동그란 챗봇 버튼 클릭 이벤트
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

      // 💬 하단 오른쪽 둥근 제미나이 AI 챗봇 버튼
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

      // 📱 하단 4개 네비게이션 탭 바
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