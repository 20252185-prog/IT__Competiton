import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../constants/colors.dart';

class ChatbotScreen extends StatefulWidget {
  final VoidCallback onClose;
  const ChatbotScreen({super.key, required this.onClose});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  // 🔑 구글 AI Studio 개인 계정 키
  // 키를 비워서 저장 (Ctrl + S)
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  GenerativeModel? _model;
  ChatSession? _chatSession;
  bool _isLoading = false;

  final List<Map<String, String>> _messages = [
    {
      'from': 'bot',
      'text': '안녕하세요! 👋 Gemini AI입니다.\n주거, 자산, 취업 등 궁금한 것은 무엇이든 편하게 질문해보세요!'
    },
  ];

  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _initGemini();
  }

  void _initGemini() {
    // 💡 키가 완전히 비어있을 때만 차단하도록 수정되었습니다!
    if (_apiKey.isEmpty) {
      print('⚠️ [Gemini Error] API 키가 비어 있습니다.');
      return;
    }

    try {
      _model = GenerativeModel(
        model: 'gemini-3-flash-preview', // 최신 권장 모델 (안 될 경우 'gemini-1.5-flash'로 변경)
        apiKey: _apiKey,
      );
      _chatSession = _model!.startChat();
      print('✅ Gemini AI가 성공적으로 초기화되었습니다!');
    } catch (e) {
      print('❌ Gemini 초기화 에러: $e');
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
          _messages.add({'from': 'bot', 'text': response.text ?? '답변을 생성하지 못했습니다.'});
        });
      } else {
        setState(() {
          _messages.add({'from': 'bot', 'text': 'API 키를 다시 확인해 주세요 (초기화 실패).'});
        });
      }
    } catch (e) {
      // 💡 터미널에 진짜 원인이 찍히도록 print 추가
      print('❌ 메세지 전송 실패 원인: $e');
      setState(() {
        _messages.add({'from': 'bot', 'text': '네트워크 오류가 발생했거나 API 키가 올바르지 않습니다.\n($e)'});
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
          
          // --- 헤더 (상단) ---
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

          // --- 대화 내역 목록 ---
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

          // --- 하단 입력창 ---
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