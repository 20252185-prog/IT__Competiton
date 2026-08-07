import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/app_data.dart';
import '../widgets/app_card.dart';
import '../widgets/back_button.dart';
import '../widgets/grid_menu_card.dart';
import '../widgets/section_header.dart';

class EmploymentTab extends StatefulWidget {
  const EmploymentTab({super.key});
  @override
  State<EmploymentTab> createState() => _EmploymentTabState();
}

class _EmploymentTabState extends State<EmploymentTab> {
  String? _activeSection;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _activeSection == null
          ? _buildHome()
          : _activeSection == 'contract'
              ? _buildContract()
              : _buildJobs(),
    );
  }

  Widget _buildHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1F3A5F), Color(0xFF3B6EA5)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('취업 가이드', style: TextStyle(fontSize: 11, color: Colors.white60, letterSpacing: 1, fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
              Text('내 권리는 내가 지킨다', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
              SizedBox(height: 2),
              Text('계약서부터 취업 채널까지 한 번에', style: TextStyle(fontSize: 13, color: Colors.white70)),
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
          children: [
            GridMenuCard(
              icon: Icons.assignment_outlined,
              label: '근로계약서 가이드',
              iconColor: const Color(0xFFEF4444),
              iconBg: const Color(0xFFFEF2F2),
              onTap: () => setState(() => _activeSection = 'contract'),
            ),
            GridMenuCard(
              icon: Icons.search,
              label: '주요 구직 사이트',
              iconColor: const Color(0xFF9333EA),
              iconBg: const Color(0xFFF5F3FF),
              onTap: () => setState(() => _activeSection = 'jobs'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContract() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackButton2(label: '취업', onTap: () => setState(() => _activeSection = null)),
        const SectionHeader(title: '근로계약서 가이드', subtitle: '서명 전 핵심 법률 체크포인트'),
        ...contractGuideItems.map((item) {
          final important = item['important'] as bool;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorder),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4)],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (important)
                    Container(width: 4, margin: const EdgeInsets.only(right: 12), decoration: BoxDecoration(color: const Color(0xFFF87171), borderRadius: BorderRadius.circular(2)))
                  else
                    const SizedBox(width: 0),
                  Icon(important ? Icons.error_outline : Icons.check_circle_outline, size: 16, color: important ? const Color(0xFFEF4444) : const Color(0xFF22C55E)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kForeground)),
                        const SizedBox(height: 4),
                        Text(item['desc'] as String, style: const TextStyle(fontSize: 12, color: kMutedFg, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFED7AA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('💡 임금체불 시 대처법 & 간이대지급금', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9A3412))),
              SizedBox(height: 6),
              Text('임금을 받지 못했다면 관할 고용노동관서 또는 1350으로 신고하세요.\n체불 확인 시 국가가 사업주 대신 최대 1,000만원(재직자 700만원)까지 지급해 주는 \'간이대지급금\' 제도를 신청할 수 있습니다.', style: TextStyle(fontSize: 12, color: Color(0xFFC2410C), height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildJobs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackButton2(label: '취업', onTap: () => setState(() => _activeSection = null)),
        const SectionHeader(title: '주요 구직 사이트', subtitle: '대표 구직 채널 및 직종별 정보'),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBorder)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('주요 구직 사이트', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kMutedFg, letterSpacing: 0.5)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: jobSites.map((site) {
                  return Column(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: Color(site['color'] as int),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: Center(
                          child: Text(
                            site['symbol'] as String,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(site['name'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: kForeground), textAlign: TextAlign.center),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        ...jobCategories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat['icon'] as String, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cat['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kForeground)),
                        const SizedBox(height: 4),
                        Text(cat['tip'] as String, style: const TextStyle(fontSize: 12, color: kMutedFg, height: 1.4)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: (cat['sites'] as List<String>).map((site) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: kSecondary, borderRadius: BorderRadius.circular(20)),
                              child: Text(site, style: const TextStyle(fontSize: 11, color: kPrimary, fontWeight: FontWeight.w500)),
                            );
                          }).toList(),
                        ),
                      ],
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
}