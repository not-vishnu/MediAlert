import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedProgressRing extends StatefulWidget {
  final double percentage;

  final double size;

  final double strokeWidth;

  final List<Color> colors;

  const AnimatedProgressRing({
    super.key,
    required this.percentage,
    this.size = 120,
    this.strokeWidth = 12,
    this.colors = const [Color(0xff6C63FF), Color(0xff4A90E2)],
  });

  @override
  State<AnimatedProgressRing> createState() => _AnimatedProgressRingState();
}

class _AnimatedProgressRingState extends State<AnimatedProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    animation = Tween<double>(
      begin: 0,
      end: widget.percentage,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.percentage != widget.percentage) {
      animation =
          Tween<double>(begin: animation.value, end: widget.percentage).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );

      controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return CustomPaint(
          painter: ProgressRingPainter(
            percentage: animation.value,
            strokeWidth: widget.strokeWidth,
            colors: widget.colors,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${animation.value.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text("Adherence", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  final double percentage;

  final double strokeWidth;

  final List<Color> colors;

  ProgressRingPainter({
    required this.percentage,
    required this.strokeWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = min(size.width, size.height) / 2 - strokeWidth;

    final background = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, background);

    final foreground = Paint()
      ..shader = SweepGradient(
        colors: colors,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final sweep = 2 * pi * (percentage.clamp(0, 100) / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweep,
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressRingPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
