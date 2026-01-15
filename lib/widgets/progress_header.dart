import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final int index;
  final int total;
  final int timeLeft;

  const ProgressHeader({
    super.key,
    required this.index,
    required this.total,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Soal ${index + 1} / $total',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('⏱ $timeLeft s'),
          ],
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: (index + 1) / total),
          duration: const Duration(milliseconds: 500),
          builder: (_, value, __) => LinearProgressIndicator(
            value: value,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
