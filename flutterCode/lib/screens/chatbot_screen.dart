import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/app_data.dart';

class ChatbotScreen extends StatefulWidget {
  final VoidCallback onClose;
  const ChatbotScreen({super.key, required this.onClose});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [
    {'from': 'bot', 'text': '안녕하세요! 주거·자산·취업에 관해 궁금한 점을 물어보세요 😊'},
  ];
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final quickQuestions = ['계약서 팁', '청약 방법', '월세 지원금', '퇴직금 조건'];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'from': 'user', 'text': text});
      _messages.add({'from': 'bot', 'text': getBotReply(text)});
    });
    _ctrl.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackground,
      child: Column(
        children: [
          const SizedBox(height: 44),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(color: kCard, border: Border(bottom: BorderSide(color: kBorder))),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                  child: const Icon(Icons.smart_toy_outlined, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI 도우미', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kForeground)),
                      Text('● 온라인', style: TextStyle(fontSize: 11, color: Color(0xFF22C55E), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: kMuted, shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 16, color: kMutedFg),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final msg = _messages[i];
                final isUser = msg['from'] == 'user';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Container(
                          width: 28, height: 28,
                          decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                          child: const Icon(Icons.smart_toy_outlined, size: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isUser ? kPrimary : kCard,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isUser ? 16 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 16),
                            ),
                            border: isUser ? null : Border.all(color: kBorder),
                          ),
                          child: Text(
                            msg['text']!,
                            style: TextStyle(fontSize: 13, color: isUser ? Colors.white : kForeground, height: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_messages.length <= 3)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: quickQuestions.map((q) {
                  return GestureDetector(
                    onTap: () => _send(q),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kSecondary,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kBorder),
                      ),
                      child: Text(q, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kPrimary)),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: const BoxDecoration(color: kCard, border: Border(top: BorderSide(color: kBorder))),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: kMuted, borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: _ctrl,
                      style: const TextStyle(fontSize: 13, color: kForeground),
                      decoration: const InputDecoration(
                        hintText: '질문을 입력하세요...',
                        hintStyle: TextStyle(fontSize: 13, color: kMutedFg),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: _send,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _send(_ctrl.text),
                  child: Container(
                    width: 36, height: 36,
                    decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                    child: const Icon(Icons.send, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}