import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../constants/colors.dart';

class ChatbotScreen extends StatefulWidget {
  final VoidCallback onClose;
  const ChatbotScreen({super.key, required this.onClose});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  GenerativeModel? _model;
  ChatSession? _chatSession;
  bool _isLoading = false;

  final List<Map<String, String>> _messages = [
    {
      'from': 'bot',
      'text': '안녕하세요! 👋 Firebase Gemini AI입니다.\n사회초년생 가이드 앱에 대해 궁금한 점이나 주거, 청년 정책 등 무엇이든 편하게 질문해보세요!'
    },
  ];

  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _initAi();
  }

  // 💡 API 키 없이 Firebase 인증으로 바로 AI 연결!
  void _initAi() {
    try {
      _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-1.5-flash',
      );
      _chatSession = _model!.startChat();
      print('✅ Firebase Gemini AI가 성공적으로 초기화되었습니다!');
    } catch (e) {
      print('❌ AI 초기화 실패: $e');
    }
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    setState(() {
      _messages.add({'from': 'user', 'text': text});
      _isLoading = true;
    });

    _ctrl.clear();
    _scrollToBottom();

    try {
      if (_chatSession != null) {
        final response = await _chatSession!.sendMessage(Content.text(text));
        setState(() {
          _messages.add({
            'from': 'bot',
            'text': response.text ?? '답변을 생성하지 못했습니다.'
          });
        });
      } else {
        setState(() {
          _messages.add({
            'from': 'bot',
            'text': 'AI 연결 준비 중입니다. 잠시 후 다시 시도해 주세요.'
          });
        });
      }
    } catch (e) {
      print('❌ 메세지 전송 실패: $e');
      setState(() {
        _messages.add({'from': 'bot', 'text': '오류가 발생했습니다: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackground,
      child: Column(
        children: [
          const SizedBox(height: 44),
          
          // --- 헤더 ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: kCard,
              border: Border(bottom: BorderSide(color: kBorder)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                  child: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gemini AI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kForeground)),
                      Text('● 온라인', style: TextStyle(fontSize: 11, color: Color(0xFF22C55E), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: kMuted, shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 16, color: kMutedFg),
                  ),
                ),
              ],
            ),
          ),

          // --- 메시지 목록 ---
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
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                          child: const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
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

          // --- 입력창 ---
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: const BoxDecoration(
              color: kCard,
              border: Border(top: BorderSide(color: kBorder)),
            ),
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
                        hintText: '궁금한 것은 제미나이에게 질문해보세요...',
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
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _isLoading ? kMutedFg : kPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.send, size: 16, color: Colors.white),
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