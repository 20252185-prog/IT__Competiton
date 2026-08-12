import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../models/app_data.dart';
import '../widgets/app_card.dart';
import '../widgets/back_button.dart';
import '../widgets/section_header.dart';
import '../widgets/tag_badge.dart';

class MoreTab extends StatefulWidget {
  const MoreTab({super.key});
  @override
  State<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> {
  bool _activeContacts = false;
  bool _showAddForm = false;
  static const _storageKey = 'emergency_contacts_added';
  final List<Map<String, String>> _contacts = List.from(defaultContacts);
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  String _category = '기타';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    super.dispose();
  }

  // 연락처를 누르면 기기 전화 앱으로 바로 연결(다이얼)한다.
  Future<void> _callNumber(String number) async {
    final tel = number.replaceAll(RegExp(r'[^0-9+]'), '');
    if (tel.isEmpty) return;
    try {
      await launchUrl(Uri.parse('tel:$tel'));
    } catch (e) {
      debugPrint('전화 연결 실패: $e');
    }
  }

  // 기기에 저장해 둔 연락처를 불러와 기본 연락처 뒤에 이어붙임.
  // 이 값은 이 기기의 로컬 저장소에만 있으므로 다른 사람 앱과는 공유되지 않음.
  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;
    final List<dynamic> decoded = jsonDecode(raw);
    final added = decoded
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
    if (!mounted) return;
    setState(() {
      _contacts.addAll(added);
    });
  }

  // 사용자가 직접 추가한 연락처(기본 연락처 이후 부분)만 저장.
  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final added = _contacts.sublist(defaultContacts.length);
    await prefs.setString(_storageKey, jsonEncode(added));
  }

  void _addContact() {
    if (_nameCtrl.text.isEmpty || _numberCtrl.text.isEmpty) return;
    setState(() {
      _contacts.add({'name': _nameCtrl.text, 'number': _numberCtrl.text, 'category': _category});
      _nameCtrl.clear();
      _numberCtrl.clear();
      _showAddForm = false;
    });
    _saveContacts();
  }

  @override
  Widget build(BuildContext context) {
    if (_activeContacts) return _buildContacts();
    return _buildHome();
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('기능', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kMutedFg, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          _menuItem(Icons.phone_outlined, '비상연락처', trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: kSecondary, borderRadius: BorderRadius.circular(20)),
            child: Text('${_contacts.length}개', style: const TextStyle(fontSize: 11, color: kPrimary, fontWeight: FontWeight.w500)),
          ), onTap: () => setState(() => _activeContacts = true)),
          const SizedBox(height: 20),
          const Text('앱 정보', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kMutedFg, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          _menuItem(Icons.campaign_outlined, '공지사항'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, {Widget? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBorder)),
        child: Row(
          children: [
            Icon(icon, size: 16, color: kMutedFg),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: kForeground))),
            trailing ?? const Icon(Icons.chevron_right, size: 16, color: kMutedFg),
          ],
        ),
      ),
    );
  }

  Widget _buildContacts() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackButton2(label: '더보기', onTap: () => setState(() { _activeContacts = false; _showAddForm = false; })),
          Row(
            children: [
              const Expanded(child: SectionHeader(title: '비상연락처', subtitle: '긴급 상황 시 빠르게 연락하세요')),
              GestureDetector(
                onTap: () => setState(() => _showAddForm = !_showAddForm),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text('추가', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showAddForm) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('새 연락처 추가', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kForeground)),
                  const SizedBox(height: 12),
                  _input(_nameCtrl, '이름 (예: 집주인)'),
                  const SizedBox(height: 8),
                  _input(_numberCtrl, '전화번호', type: TextInputType.phone),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: InputDecoration(
                      filled: true, fillColor: kMuted,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 13, color: kForeground),
                    items: ['긴급', '주거', '취업', '금융', '복지', '기타'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _addContact,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(8)),
                            child: const Center(child: Text('저장', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showAddForm = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(color: kMuted, borderRadius: BorderRadius.circular(8)),
                            child: const Center(child: Text('취소', style: TextStyle(fontSize: 13, color: kMutedFg, fontWeight: FontWeight.w500))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          ..._contacts.asMap().entries.map((entry) {
            final i = entry.key;
            final c = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => _callNumber(c['number']!),
                behavior: HitTestBehavior.opaque,
                child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBorder)),
                child: Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 16, color: kMutedFg),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kForeground)),
                          Text(c['number']!, style: const TextStyle(fontSize: 12, color: kMutedFg)),
                        ],
                      ),
                    ),
                    TagBadge(text: c['category']!, bg: tagColor(c['category']!), fg: tagTextColor(c['category']!)),
                    if (i >= defaultContacts.length) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() => _contacts.removeAt(i));
                          _saveContacts();
                        },
                        child: const Icon(Icons.close, size: 16, color: kMutedFg),
                      ),
                    ],
                  ],
                ),
              ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String hint, {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: const TextStyle(fontSize: 13, color: kForeground),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: kMutedFg),
        filled: true, fillColor: kMuted,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
