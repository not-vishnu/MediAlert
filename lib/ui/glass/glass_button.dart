import 'dart:ui';

import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final VoidCallback onTap;

  final String text;

  const GlassButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: Material(
          color: Colors.white24,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white38,
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff5B8CFF),
                    Color(0xff8F6CFF),
                  ],
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
