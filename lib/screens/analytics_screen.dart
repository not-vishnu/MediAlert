import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Widget _glass({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
    double radius = 26,
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(height: 10),
        const Text(
          "Weekly Adherence",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Your medicine adherence for the last 5 days",
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        const SizedBox(height: 24),
        _glass(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
          child: SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.white.withValues(alpha: .12),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        const days = ["Mon", "Tue", "Wed", "Thu", "Fri"];
                        final i = value.toInt() - 1;
                        if (i < 0 || i >= days.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            days[i],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 25,
                      getTitlesWidget: (value, meta) => Text(
                        "${value.toInt()}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
                barGroups: [
                  _bar(1, 80),
                  _bar(2, 60),
                  _bar(3, 95),
                  _bar(4, 70),
                  _bar(5, 100),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _statBox("Avg", "81%")),
            const SizedBox(width: 12),
            Expanded(child: _statBox("Best", "100%")),
            const SizedBox(width: 12),
            Expanded(child: _statBox("Streak", "3d")),
          ],
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 18,
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFF4DA3FF), Color(0xFF9F7BFF)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ],
    );
  }

  Widget _statBox(String label, String value) {
    return _glass(
      radius: 20,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
