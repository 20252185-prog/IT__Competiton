import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:url_launcher/url_launcher.dart';
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

  // 말풍선 안 링크의 탭 인식기들. 빌드마다 새로 만들고 이전 것은 정리한다.
  final List<TapGestureRecognizer> _linkRecognizers = [];

  // http(s) URL 또는 스킴 없는 도메인(applyhome.co.kr, housing.seoul.go.kr 등)을 인식.
  static final RegExp _urlPattern = RegExp(
    r'(?:https?:\/\/)?(?:www\.)?[a-zA-Z0-9][a-zA-Z0-9.-]*\.(?:go\.kr|co\.kr|or\.kr|com|net|org|io|kr)(?:\/[^\s]*)?',
    caseSensitive: false,
  );

  @override
  void initState() {
    super.initState();
    _initAi();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    for (final r in _linkRecognizers) {
      r.dispose();
    }
    super.dispose();
  }

  // 링크(또는 스킴 없는 도메인)를 외부 브라우저로 연다.
  Future<void> _openUrl(String raw) async {
    var s = raw.replaceAll(RegExp(r'[.,)\]]+$'), ''); // 뒤 문장부호 제거
    if (!s.startsWith('http')) s = 'https://$s';
    final uri = Uri.tryParse(s);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('링크 열기 실패: $e');
    }
  }

  // 메시지 텍스트에서 URL만 탭 가능한 링크로 바꿔 렌더링한다.
  // 기존 텍스트 스타일(크기·색·줄간격)은 그대로 유지한다.
  Widget _buildMessageText(String text, bool isUser) {
    final baseStyle = TextStyle(
      fontSize: 13,
      color: isUser ? Colors.white : kForeground,
      height: 1.5,
    );
    final linkStyle = baseStyle.copyWith(
      color: isUser ? Colors.white : kPrimary,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w600,
    );

    final spans = <InlineSpan>[];
    int last = 0;
    for (final m in _urlPattern.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start)));
      }
      final url = m.group(0)!;
      final recognizer = TapGestureRecognizer()..onTap = () => _openUrl(url);
      _linkRecognizers.add(recognizer);
      spans.add(TextSpan(text: url, style: linkStyle, recognizer: recognizer));
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }

    return Text.rich(TextSpan(style: baseStyle, children: spans));
  }

  // 별도 API 키 없이 Firebase 인증으로 AI에 연결한다.
  void _initAi() {
    try {
      _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.6-flash',
        systemInstruction: Content.system('사회초년생의 주거·자산·취업·청년정책 관련 질문에만 답하고, 벗어난 질문은 정중히 거절.정확한 마감·신청기간은 공고/공식 링크에서 확인할 수 있도록 사이트 안내해주기. 단, URL 지어내지 말 것'),
      );
      _chatSession = _model!.startChat();
    } catch (e) {
      debugPrint('AI 초기화 실패: $e');
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

    // 응답을 기다리는 동안 사용자가 챗봇 창을 닫을 수 있으므로
    // await 이후에는 항상 mounted를 확인한 뒤 setState를 호출한다.
    try {
      if (_chatSession != null) {
        final response = await _chatSession!.sendMessage(Content.text(text));
        if (!mounted) return;
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
      debugPrint('메시지 전송 실패: $e');
      if (!mounted) return;
      setState(() {
        _messages.add({'from': 'bot', 'text': '오류가 발생했습니다: $e'});
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      // dispose 이후 콜백이 도착하면 컨트롤러 접근에서 예외가 나므로 함께 확인.
      if (mounted && _scrollCtrl.hasClients) {
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
    // 이전 빌드에서 만든 링크 탭 인식기를 정리하고, 이번 빌드에서 다시 만든다.
    for (final r in _linkRecognizers) {
      r.dispose();
    }
    _linkRecognizers.clear();

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
                          child: _buildMessageText(msg['text']!, isUser),
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