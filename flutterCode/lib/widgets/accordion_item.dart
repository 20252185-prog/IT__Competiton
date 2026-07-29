import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AccordionItem extends StatefulWidget {
  final String title;
  final List<String> steps;
  const AccordionItem({super.key, required this.title, required this.steps});

  @override
  State<AccordionItem> createState() => _AccordionItemState();
}

class _AccordionItemState extends State<AccordionItem> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _open = !_open),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(child: Text(widget.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kForeground))),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, size: 18, color: kMutedFg),
                  ),
                ],
              ),
            ),
          ),
          if (_open)
            Container(
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: kBorder))),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: List.generate(widget.steps.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20, height: 20,
                          decoration: const BoxDecoration(color: kAccent, shape: BoxShape.circle),
                          child: Center(child: Text('${i + 1}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(widget.steps[i], style: const TextStyle(fontSize: 13, color: kForeground, height: 1.5))),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}