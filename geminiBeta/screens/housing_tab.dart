import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/app_data.dart';
import '../widgets/accordion_item.dart';
import '../widgets/app_card.dart';
import '../widgets/grid_menu_card.dart';
import '../widgets/section_header.dart';
import '../widgets/tag_badge.dart';

class HousingTab extends StatefulWidget {
  const HousingTab({super.key});

  @override
  State<HousingTab> createState() => _HousingTabState();
}

class _HousingTabState extends State<HousingTab> {
  String? _activeSection;
  final Set<int> _checked = {};
  String _selectedTroubleCategory = '층간소음';

  // 🔙 이전으로 돌아가기 버튼 공통 위젯
  Widget _buildBackButton(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _activeSection = null),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back_ios_new, size: 16, color: kPrimary),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _activeSection == null
            ? _buildHome()
            : _activeSection == 'contract'
                ? _buildContract()
                : _activeSection == 'checklist'
                    ? _buildChecklist()
                    : _activeSection == 'trouble'
                        ? _buildTrouble()
                        : _buildTerms(),
      ),
    );
  }

  // 1. 메인 주거 홈 화면
  Widget _buildHome() {
    final sections = [
      {'id': 'terms', 'label': '기본 용어 설명', 'icon': Icons.menu_book_outlined, 'iconColor': 0xFF7C3AED, 'iconBg': 0xFFF5F3FF},
      {'id': 'checklist', 'label': '방 구하기 체크리스트', 'icon': Icons.check_box_outlined, 'iconColor': 0xFF16A34A, 'iconBg': 0xFFF0FDF4},
      {'id': 'trouble', 'label': '트러블슈팅 가이드', 'icon': Icons.warning_amber_outlined, 'iconColor': 0xFFEA580C, 'iconBg': 0xFFFFF7ED},
      {'id': 'contract', 'label': '계약서 팁', 'icon': Icons.description_outlined, 'iconColor': 0xFF2563EB, 'iconBg': 0xFFEFF6FF},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('주거 가이드', style: TextStyle(fontSize: 11, color: Colors.white60, letterSpacing: 1, fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
              Text('혼자 살기, 처음이라도 괜찮아', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
              SizedBox(height: 2),
              Text('계약부터 생활까지 알아야 할 모든 것', style: TextStyle(fontSize: 13, color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: sections.map((s) {
            return GridMenuCard(
              icon: s['icon'] as IconData,
              label: s['label'] as String,
              iconColor: Color(s['iconColor'] as int),
              iconBg: Color(s['iconBg'] as int),
              onTap: () => setState(() => _activeSection = s['id'] as String),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // 2. 월세 계약서 팁
  Widget _buildContract() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton('주거 홈으로'),
        const SectionHeader(title: '월세 계약서 팁', subtitle: '계약 전후 반드시 확인해야 할 체크포인트'),
        ...contractTips.map((tip) {
          Color bg, fg;
          if (tip['tag'] == '필수') {
            bg = const Color(0xFFFEE2E2);
            fg = const Color(0xFFB91C1C);
          } else if (tip['tag'] == '권장') {
            bg = const Color(0xFFDBEAFE);
            fg = const Color(0xFF1D4ED8);
          } else {
            bg = kMuted;
            fg = kMutedFg;
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tip['title']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kForeground)),
                        const SizedBox(height: 4),
                        Text(tip['desc']!, style: const TextStyle(fontSize: 12, color: kMutedFg, height: 1.5)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TagBadge(text: tip['tag']!, bg: bg, fg: fg),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  // 3. 자취방 구하기 체크리스트
  Widget _buildChecklist() {
    final progress = _checked.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton('주거 홈으로'),
        const SectionHeader(title: '자취방 구하기 체크리스트'),
        AppCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$progress / ${checklistItems.length} 완료', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kForeground)),
                  Text('${(checklistItems.isEmpty ? 0 : (progress / checklistItems.length * 100)).round()}%', style: const TextStyle(fontSize: 12, color: kMutedFg)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: checklistItems.isEmpty ? 0 : progress / checklistItems.length,
                  backgroundColor: kMuted,
                  color: kAccent,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(checklistItems.length, (i) {
          final checked = _checked.contains(i);
          return GestureDetector(
            onTap: () => setState(() => checked ? _checked.remove(i) : _checked.add(i)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorder),
              ),
              child: Row(
                children: [
                  Icon(checked ? Icons.check_box : Icons.check_box_outline_blank, size: 20, color: checked ? kAccent : kMutedFg),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      checklistItems[i],
                      style: TextStyle(
                        fontSize: 13,
                        color: checked ? kMutedFg : kForeground,
                        decoration: checked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  // 4. 트러블슈팅 가이드
  Widget _buildTrouble() {
    final filteredItems = troubleshootingItems
        .where((item) => item['category'] == _selectedTroubleCategory)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton('주거 홈으로'),
        const SectionHeader(title: '트러블슈팅 가이드', subtitle: '자취 중 자주 발생하는 문제와 대처법'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: troubleshootingCategories.map((category) {
              final isSelected = _selectedTroubleCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTroubleCategory = category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimary : kCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? kPrimary : kBorder),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : kMutedFg,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        ...filteredItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AccordionItem(
              title: '${item['icon']} ${item['title']}',
              steps: List<String>.from(item['steps'] as List),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  // 5. 자취 기본 용어
  Widget _buildTerms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton('주거 홈으로'),
        const SectionHeader(title: '자취 기본 용어', subtitle: '헷갈리기 쉬운 부동산·임대차 용어 정리'),
        ...housingTerms.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['term']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kAccent)),
                  const SizedBox(height: 4),
                  Text(item['def']!, style: const TextStyle(fontSize: 12, color: kMutedFg, height: 1.5)),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}