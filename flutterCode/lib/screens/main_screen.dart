import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import 'assets_tab.dart';
import 'chatbot_screen.dart';
import 'employment_tab.dart';
import 'housing_tab.dart';
import 'more_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _chatOpen = false;

  final List<Widget> _tabs = const [
    HousingTab(),
    AssetsTab(),
    EmploymentTab(),
    MoreTab(),
  ];

  final List<String> _titles = ['주거', '자산', '취업', '더보기'];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: kBackground,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 44),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: const BoxDecoration(
                    color: kCard,
                    border: Border(bottom: BorderSide(color: kBorder, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _titles[_currentIndex],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _tabs,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: kCard,
                    border: Border(top: BorderSide(color: kBorder, width: 1)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: List.generate(4, (i) {
                        final icons = [Icons.home_outlined, Icons.savings_outlined, Icons.work_outline, Icons.more_horiz];
                        final activeIcons = [Icons.home, Icons.savings, Icons.work, Icons.more_horiz];
                        final labels = ['주거', '자산', '취업', '더보기'];
                        final active = _currentIndex == i;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _currentIndex = i),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 12),
                                Icon(
                                  active ? activeIcons[i] : icons[i],
                                  size: 22,
                                  color: active ? kPrimary : kMutedFg,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  labels[i],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: active ? kPrimary : kMutedFg,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (active)
                                  Container(width: 16, height: 2, decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(1)))
                                else
                                  const SizedBox(height: 2),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            if (!_chatOpen)
              Positioned(
                bottom: 80,
                right: 16,
                child: GestureDetector(
                  onTap: () => setState(() => _chatOpen = true),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: kPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
                  ),
                ),
              ),
            if (_chatOpen)
              ChatbotScreen(onClose: () => setState(() => _chatOpen = false)),
          ],
        ),
      ),
    );
  }
}