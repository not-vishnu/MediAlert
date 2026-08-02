import 'package:flutter/material.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffdfefff),
            Color(0xffedf6ff),
            Color(0xffffffff),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -50,
            child: _circle(
              220,
              Colors.blue.withOpacity(.20),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -60,
            child: _circle(
              260,
              Colors.purple.withOpacity(.15),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
