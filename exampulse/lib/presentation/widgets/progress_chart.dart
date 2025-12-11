import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ProgressChart extends StatelessWidget {
  final List<double> scores;

  const ProgressChart({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) return const SizedBox();

    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              Colors.blueAccent.shade700,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 24, 18, 12),
          child: LineChart(
            mainData(),
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < scores.length; i++) {
      spots.add(FlSpot(i.toDouble(), scores[i]));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        // const kalabilir çünkü içinde fonksiyon yok
        getDrawingHorizontalLine: (value) => const FlLine(color: Colors.white10, strokeWidth: 1),
        getDrawingVerticalLine: (value) => const FlLine(color: Colors.white10, strokeWidth: 1),
      ),
      // DÜZELTME: Buradaki 'const' ifadesini kaldırdık!
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 100,
            getTitlesWidget: leftTitleWidgets, // Hata veren kısım burasıydı
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (scores.length - 1).toDouble(),
      minY: 0,
      maxY: 550,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.white,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 10);
    return Text(value.toInt().toString(), style: style, textAlign: TextAlign.left);
  }
}