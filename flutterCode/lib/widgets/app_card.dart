import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final Border? border;
  const AppCard({super.key, required this.child, this.padding, this.color, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? kCard,
        borderRadius: BorderRadius.circular(12),
        border: border ?? Border.all(color: kBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: child,
    );
  }
}