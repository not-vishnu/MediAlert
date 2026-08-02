import 'dart:ui';

import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Widget _glass({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    double radius = 20,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, .18),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, .30),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _entry({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _glass(
        padding: EdgeInsets.zero,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: CircleAvatar(
            backgroundColor: iconColor.withValues(alpha: .25),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(height: 10),
        const Text(
          "Medicine History",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Recent activity",
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        const SizedBox(height: 24),
        _entry(
          icon: Icons.check_circle,
          iconColor: Colors.greenAccent,
          title: "Paracetamol",
          subtitle: "Taken • 8:00 AM",
        ),
        _entry(
          icon: Icons.cancel,
          iconColor: Colors.redAccent,
          title: "Vitamin C",
          subtitle: "Missed • 1:00 PM",
        ),
        _entry(
          icon: Icons.schedule,
          iconColor: Colors.orangeAccent,
          title: "Insulin",
          subtitle: "Skipped",
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}
