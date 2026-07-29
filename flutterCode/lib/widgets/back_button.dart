import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BackButton2 extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const BackButton2({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back_ios, size: 14, color: kAccent),
            Text(label, style: const TextStyle(fontSize: 13, color: kAccent, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
