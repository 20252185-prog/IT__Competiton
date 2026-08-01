import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'app_card.dart';

class GridMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;
  const GridMenuCard({super.key, required this.icon, required this.label, required this.iconColor, required this.iconBg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kForeground)),
            const SizedBox(height: 8),
            const Icon(Icons.chevron_right, size: 16, color: kMutedFg),
          ],
        ),
      ),
    );
  }
}