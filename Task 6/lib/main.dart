// Transcribed from the scanned Experiment 6 report.
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: AnalyticsPage()),
);

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FC),
      appBar: AppBar(
        title: const Text(
          'Course Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, Nina 📊',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Here's your weekly summary",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                'https://picsum.photos/700/300',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: stat(Icons.track_changes, 'Modules', '12')),
                const SizedBox(width: 12),
                Expanded(child: stat(Icons.star, 'Rating', '4.8')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: stat(Icons.timer, 'Hours', '36h')),
                const SizedBox(width: 12),
                Expanded(child: stat(Icons.trending_up, 'Growth', '72%')),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Engagement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Colors.black12),
                ],
              ),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 1.5),
                        FlSpot(3, 4),
                        FlSpot(4, 3.5),
                        FlSpot(5, 6),
                        FlSpot(6, 5.5),
                        FlSpot(7, 7),
                        FlSpot(8, 8),
                      ],
                      isCurved: false,
                      color: const Color(0xFF6A1B9A),
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0x336A1B9A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Card(
              child: ListTile(
                leading: Icon(Icons.lightbulb, color: Colors.orange, size: 30),
                title: Text('On a roll!'),
                subtitle: Text('Your engagement rose 20% this week.'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget stat(IconData icon, String title, String value) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
    ),
    child: Row(
      children: [
        Icon(icon, size: 26, color: const Color(0xFF6A1B9A)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );
}
