import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'database_helper.dart';
import 'add_analyses_page.dart';
import 'dart:math';


class AnalysisPage extends StatefulWidget {
  @override
  static const routeName = '/analysis';
  _AnalysisPageState createState() => _AnalysisPageState();
}

enum AnalysisType { iron, calcium, vitaminD }

class _AnalysisPageState extends State<AnalysisPage> {
  AnalysisType _currentType = AnalysisType.iron;
  List<Analysis> _analyses = [];
  Map<String, dynamic> info = {};
  bool _isChart = true; 

  @override
  void initState() {
    super.initState();
    _loadAnalyses();
  }

  Future<void> _loadAnalyses() async {
    final analyses = await DatabaseHelper.getAnalyses();
    if (_currentType == AnalysisType.iron) info = await DatabaseHelper.getAnalysisInfo("iron");
    if (_currentType == AnalysisType.calcium) info = await DatabaseHelper.getAnalysisInfo("calcium");
    if (_currentType == AnalysisType.vitaminD) info = await DatabaseHelper.getAnalysisInfo("vitaminD");
    
    _updateAnalyses(analyses);
  }

  void _updateAnalyses(List<Analysis> analyses) {
    String typeName = '';
    if (_currentType == AnalysisType.iron) typeName = "Железо";
    if (_currentType == AnalysisType.calcium) typeName = "Кальций";
    if (_currentType == AnalysisType.vitaminD) typeName = "Витамин D";
    final filteredAnalyses = analyses
      .where((analysis) => analysis.type == typeName && analysis.userId == UserSession.currentUser.userId)
      .toList();
    filteredAnalyses.sort((a, b) => a.date.compareTo(b.date));
    setState(() {
      _analyses = filteredAnalyses;
    });
  }

  AnalysisType _getDataType(String type) {
    switch (type) {
      case 'Железо':
        return AnalysisType.iron;
      case 'Кальций':
        return AnalysisType.calcium;
      case 'Витамин D':
        return AnalysisType.vitaminD;
      default:
        throw Exception('Unknown Analysis Type');
    }
  }

  void _nextType() {
    setState(() {
      _currentType = AnalysisType.values[(_currentType.index + 1) % AnalysisType.values.length];
      _loadAnalyses();
    });
  }

  void _previousType() {
    setState(() {
      _currentType = AnalysisType.values[(_currentType.index - 1 + AnalysisType.values.length) % AnalysisType.values.length];
      _loadAnalyses();
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    String recommendation = '';
    Color plotColor = Colors.red;
    List<String> analyzeChanges(List<Analysis> analyses, String analysisName, String unit) {
      List<String> changes = [];

      if (analyses.length < 2) {
        return changes;
      }

      Analysis lastAnalysis = analyses[analyses.length - 1];
      Analysis previousAnalysis = analyses[analyses.length - 2];

      double change = lastAnalysis.value - previousAnalysis.value;

      if (change > 0) {
        changes.add('Показатель $analysisName увеличился на ${change.toStringAsFixed(2)} $unit (${previousAnalysis.value} -> ${lastAnalysis.value})');
      } else if (change < 0) {
        changes.add('Показатель $analysisName уменьшился на ${(change * -1).toStringAsFixed(2)} $unit (${previousAnalysis.value} -> ${lastAnalysis.value})');
      } else {
        changes.add('Показатель $analysisName остался без изменений');
      }

      return changes;
    }
    final type = info['ruType'] ?? 'Неизвестно';
    final measurementUnit = info['measurementUnit'] ?? '';
    final lowerBound = info['lowerBound'] ?? double.negativeInfinity;
    final upperBound = info['upperBound'] ?? double.infinity;
    final lowValueAdvice = info['lowValueAdvice'] ?? '';
    final highValueAdvice = info['highValueAdvice'] ?? '';
    title = _isChart ? 'График $type ($measurementUnit)' : 'Таблица $type ($measurementUnit)';
    final changes = analyzeChanges(_analyses, type, measurementUnit);
    final changeRecommendation = changes.isNotEmpty ? changes.join('. ') : '';
    recommendation = '';

    if (_analyses.isNotEmpty && _analyses.last.value < lowerBound) {
      recommendation = lowValueAdvice;
    } else if (_analyses.isNotEmpty && _analyses.last.value > upperBound) {
      recommendation = highValueAdvice;
    } else {
      recommendation = 'У вас нормальное содержание $type';
    }
    recommendation += '. $changeRecommendation';

    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Анализы', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -240,
            left: -80,
            child: Transform.rotate(
              angle: -25 * (pi / 180),
              child: Image.asset('assets/yellowDecoration.jpg', height: 380),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -30,
            child: Transform.rotate(
              angle: -20 * (pi / 180),
              child: Image.asset('assets/greenDecoration.jpg', height: 300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_left, color: Colors.black),
                      onPressed: _previousType,
                    ),
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    IconButton(
                      icon: Icon(Icons.arrow_right, color: Colors.black),
                      onPressed: _nextType,
                    ),
                  ],
                ),
                ToggleButtons(
                  children: <Widget>[
                    Icon(Icons.show_chart),
                    Icon(Icons.table_chart),
                  ],
                  isSelected: [_isChart, !_isChart],
                  onPressed: (int index) {
                    setState(() {
                      _isChart = index == 0;
                    });
                  },
                ),
                Expanded(
                  child: _isChart ? _buildChart() : _buildTable(),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightGreen,
                  ),
                  child: TextButton.icon(
                    icon: Icon(Icons.add_circle, color: Colors.black, size: 30),
                    label: Text('Добавить анализы', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AddAnalysisPage.routeName);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Рекомендации', style: TextStyle(fontSize: 24, color: Colors.black)),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    recommendation,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(
        plotBands: <PlotBand>[
            PlotBand(
              start: _currentType == AnalysisType.iron ? 2.0 : _currentType == AnalysisType.calcium ? 8.5 : 20.0,
              end: _currentType == AnalysisType.iron ? 2.0 : _currentType == AnalysisType.calcium ? 8.5 : 20.0,
              borderColor: Colors.red,
              borderWidth: 2,
            ),
            PlotBand(
              start: _currentType == AnalysisType.iron ? 4.5 : _currentType == AnalysisType.calcium ? 10.2 : 50.0,
              end: _currentType == AnalysisType.iron ? 4.5 : _currentType == AnalysisType.calcium ? 10.2 : 50.0,
              borderColor: Colors.red,
              borderWidth: 2,
          ),
        ],
      ),
      series: <LineSeries>[
        LineSeries<Analysis, DateTime>(
          dataSource: _analyses,
          xValueMapper: (Analysis analysis, _) => analysis.date,
          yValueMapper: (Analysis analysis, _) => analysis.value,
          color: Colors.green,
        ),
      ],
    );
  }

  
Widget _buildTable() {
    List<Analysis> reversedAnalyses = List.from(_analyses.reversed);

    return ListView.separated(
      itemCount: _analyses.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        final analysis = reversedAnalyses[index];
        Color valueColor;

        if (_currentType == AnalysisType.iron) {
          if (analysis.value < 2.0 || analysis.value > 4.5) {
            valueColor = Colors.red;
          } else {
            valueColor = Colors.green;
          }
        } else if (_currentType == AnalysisType.calcium) {
          if (analysis.value < 8.5 || analysis.value > 10.2) {
            valueColor = Colors.red;
          } else {
            valueColor = Colors.green;
          }
        } else {
          if (analysis.value < 20.0 || analysis.value > 50.0) {
            valueColor = Colors.red;
          } else {
            valueColor = Colors.green;
          }
        }

        String formattedDate = '${analysis.date.toLocal().day.toString().padLeft(2, '0')}.${analysis.date.toLocal().month.toString().padLeft(2, '0')}.${analysis.date.toLocal().year}';

        return ListTile(
            title: Row(
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.black),
                ),
                Spacer(),
                Text(
                  '${analysis.value}',
                  style: TextStyle(color: valueColor),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () async {
                    await DatabaseHelper.deleteAnalysis(analysis.id);
                    setState(() {
                      _analyses.removeAt(_analyses.length - 1 - index);
                    });
                  },
                ),
              ],
            ),
          );
      },
    );
  }
}
