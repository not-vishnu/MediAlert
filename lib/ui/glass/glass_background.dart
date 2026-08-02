import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBackground extends StatelessWidget {
  final Widget child;

  const GlassBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffEDF4FF),
                Color(0xffF7F9FF),
                Color(0xffEEF2FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: const BoxDecoration(
              color: Color(0xff6FA8FF),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -50,
          child: Container(
            width: 240,
            height: 240,
            decoration: const BoxDecoration(
              color: Color(0xffA38BFF),
              shape: BoxShape.circle,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 120,
            sigmaY: 120,
          ),
          child: Container(
            color: Colors.transparent,
          ),
        ),
        child,
      ],
    );
  }
}
