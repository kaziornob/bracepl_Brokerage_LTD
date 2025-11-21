import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/fund.dart';

class FundDetailsPage extends StatelessWidget {
  final FundEntity fund;
  const FundDetailsPage({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${fund.name} Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Current Balance: \$${fund.currentBalance.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
                'Available Balance: \$${fund.availableBalance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            // Text(fund.performanceData.toString()),
            const SizedBox(height: 20),
            const Text('Performance Chart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(
                      show: true,
                      border:
                          Border.all(color: const Color(0xff37434d), width: 1)),
                  lineBarsData: [
                    LineChartBarData(
                      spots: fund.performanceData.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                          show: true, color: Colors.blue.withOpacity(0.3)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Fund Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ...fund.breakdown.entries.map((entry) => Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${entry.value}%',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
