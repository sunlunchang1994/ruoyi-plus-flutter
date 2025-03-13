import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample11 extends StatefulWidget {
  const LineChartSample11({super.key});

  @override
  State<LineChartSample11> createState() => _LineChartSample11State();
}

class _LineChartSample11State extends State<LineChartSample11> {
  var baselineX = 5.0;
  var baselineY = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 18.0,
          right: 18.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  RotatedBox(
                    quarterTurns: 1,
                    child: Slider(
                      value: baselineY,
                      onChanged: (newValue) {
                        setState(() {
                          baselineY = newValue;
                        });
                      },
                      min: -10,
                      max: 10,
                    ),
                  ),
                  Expanded(
                    child: _Chart(
                      baselineX,
                      (20 - (baselineY + 10)) - 10,
                    ),
                  )
                ],
              ),
            ),
            Slider(
              value: baselineX,
              onChanged: (newValue) {
                setState(() {
                  baselineX = newValue;
                });
              },
              min: -10,
              max: 10,
            ),
          ],
        ),
      ),
    ));
  }
}

class _Chart extends StatelessWidget {
  final double baselineX;
  final double baselineY;

  const _Chart(this.baselineX, this.baselineY) : super();

  Widget getHorizontalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineX).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget getVerticalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineY).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(meta.formattedValue, style: style),
    );
  }

  FlLine getHorizontalVerticalLine(double value) {
    if ((value - baselineY).abs() <= 0.1) {
      return const FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return const FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  FlLine getVerticalVerticalLine(double value) {
    if ((value - baselineX).abs() <= 0.1) {
      return const FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return const FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        clipData: FlClipData.all(),
        lineBarsData: [
          LineChartBarData(
            spots: (){
              List<FlSpot> list = List.empty(growable: true);
              for (double i = baselineX-5; i <= baselineX+5; i++) {
                list.add(FlSpot(i, i));
              }
              return list;
            }.call(),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getHorizontalTitles,
                reservedSize: 32),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getHorizontalTitles,
                reservedSize: 32),
          ),
        ),
        gridData: FlGridData(
          show: true
        ),
        minY: -10,
        maxY: 10,
        baselineY: baselineY,
        minX: 0,
        maxX: 10,
        baselineX: baselineX,
      ),
      duration: Duration.zero,
    );
  }
}