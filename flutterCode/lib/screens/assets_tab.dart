import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/app_data.dart';
import '../widgets/app_card.dart';
import '../widgets/back_button.dart';
import '../widgets/grid_menu_card.dart';
import '../widgets/section_header.dart';
import '../widgets/tag_badge.dart';

class AssetsTab extends StatefulWidget {
  const AssetsTab({super.key});
  @override
  State<AssetsTab> createState() => _AssetsTabState();
}

class _AssetsTabState extends State<AssetsTab> {
  String? _activeSection;
  final Set<int> _expandedPolicies = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _activeSection == null
          ? _buildHome()
          : _activeSection == 'cheongyak'
              ? _buildCheongyak()
              : _buildPolicy(),
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
            gradient: const LinearGradient(colors: [Color(0xFF1A3F6F), Color(0xFF2468B2)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('자산 가이드', style: TextStyle(fontSize: 11, color: Colors.white60, letterSpacing: 1, fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
              Text('지금 시작하면 늦지 않아', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
              SizedBox(height: 2),
              Text('청약부터 정부 혜택까지 똑똑하게 챙기기', style: TextStyle(fontSize: 13, color: Colors.white70)),
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
              icon: Icons.trending_up,
              label: '청약 가이드',
              iconColor: const Color(0xFF2563EB),
              iconBg: const Color(0xFFEFF6FF),
              onTap: () => setState(() => _activeSection = 'cheongyak'),
            ),
            GridMenuCard(
              icon: Icons.card_giftcard_outlined,
              label: '확인해야 할 정부 지원금',
              iconColor: const Color(0xFF16A34A),
              iconBg: const Color(0xFFF0FDF4),
              onTap: () => setState(() => _activeSection = 'policy'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCheongyak() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackButton2(label: '자산', onTap: () => setState(() => _activeSection = null)),
        const SectionHeader(
          title: '청약 가이드', 
          subtitle: '내 집 마련의 첫걸음, 청약통장 활용법부터 신청까지'
        ),
        ...cheongyakSteps.map((step) {
          final highlight = step['highlight'] as bool;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: highlight ? kPrimary : kCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: highlight ? kPrimary : kBorder),
                boxShadow: highlight 
                    ? [BoxShadow(color: kPrimary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))]
                    : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: highlight ? Colors.white.withValues(alpha: 0.2) : kSecondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'STEP ${step['step']}', 
                      style: TextStyle(
                        fontSize: 11, 
                        fontWeight: FontWeight.w700, 
                        color: highlight ? Colors.white : kPrimary, 
                        fontFamily: 'monospace'
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String, 
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.w700, 
                            color: highlight ? Colors.white : kForeground
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step['desc'] as String, 
                          style: TextStyle(
                            fontSize: 12, 
                            color: highlight ? Colors.white70 : kMutedFg, 
                            height: 1.5
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline, size: 18, color: Color(0xFF2563EB)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '부부 개별 청약 가능: 부부가 동일한 아파트 단지에 동시에 청약을 넣어도 모두 무효 처리되지 않으며, 둘 다 당첨될 경우 먼저 신청한 건이 인정됩니다.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), height: 1.5, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.stars_outlined, size: 18, color: Color(0xFF16A34A)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '청년주택드림통장 당첨 혜택: 통장에 1년 이상 가입하고 1,000만 원 이상 납입 실적이 있으면, 당첨 시 최저 2.2%대 금리의 전용 대출(청년주택드림대출)을 지원받을 수 있습니다.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF14532D), height: 1.5, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackButton2(label: '자산', onTap: () => setState(() => _activeSection = null)),
        const SectionHeader(title: '확인해야 할 정부 지원금', subtitle: '주요 정부 지원금 3가지 상세 안내'),
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            '* 신청 전 공식 기관의 최신 공고 재확인 요망 *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFFDC2626),
            ),
          ),
        ),
        ...List.generate(governmentPolicies.length, (index) {
          final policy = governmentPolicies[index];
          final isExpanded = _expandedPolicies.contains(index);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TagBadge(
                        text: policy['tag'] as String,
                        bg: tagColor(policy['tag'] as String),
                        fg: tagTextColor(policy['tag'] as String),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    policy['title'] as String,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kForeground),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    policy['summary'] as String,
                    style: const TextStyle(fontSize: 12, color: kMutedFg),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: kBorder),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedPolicies.remove(index);
                        } else {
                          _expandedPolicies.add(index);
                        }
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isExpanded ? '상세내용 접기 ' : '상세내용 보기 ',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kAccent),
                          ),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            size: 16,
                            color: kAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 12),
                    _infoRow('📞 전화문의', policy['call'] as String),
                    _infoRow('📝 신청방법', policy['method'] as String),
                    _infoRow('🎁 지원형태', policy['type'] as String),
                    _infoRow('⚖️ 제공근거', policy['legal'] as String),
                    const SizedBox(height: 8),
                    const Text('📌 가입 및 선정 기준:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kForeground)),
                    const SizedBox(height: 6),
                    ...(policy['details'] as List<String>).map((detail) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 12, color: kAccent, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                detail,
                                style: const TextStyle(fontSize: 12, color: kForeground, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kMutedFg)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, color: kForeground, height: 1.3)),
          ),
        ],
      ),
    );
  }
}