import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysesPage extends StatelessWidget {
  static const routeName = '/analyses';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Анализы'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.black),
            onPressed: () {},
            tooltip: 'Добавить данные',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <LineSeries<DateTime, double>>[
                LineSeries<DateTime, double>(
                  dataSource: [

                  ],
                  xValueMapper: (DateTime date, int index) => index.toDouble(),
                  yValueMapper: (DateTime date, int index) => index.toDouble(),

                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'График железа',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 32),
          Text(
            'Рекомендации',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Совет дня: у вас понижено железо, рекомендуем добавить в рацион зелёные яблоки и мясо.',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}