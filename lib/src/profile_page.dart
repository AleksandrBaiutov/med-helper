import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import 'main_page.dart';
import 'login_page.dart';
import 'database_helper.dart';

class ProfilePage extends StatefulWidget {
  @override
  static const routeName = '/profile';
  const ProfilePage({Key? key}) : super(key: key);
  _ProfilePageState createState() => _ProfilePageState();
}
enum AnalysisType { iron, calcium, vitaminD }

class _ProfilePageState extends State<ProfilePage> {
  final List<Analysis> _analyses = [];
  String? selectedAnalysis;
  DateTime? selectedDate;
  AnalysisType _currentType = AnalysisType.iron;
  String recommendation = '';
  Map<String, dynamic> info = {};
  bool _isChart = true; 

  @override
  void initState() {
    super.initState();
    loadAnalyses();
  }

  Future<void> loadAnalyses() async {
    final List<Analysis> analyses = await DatabaseHelper.getAnalyses();
    if (_currentType == AnalysisType.iron) info = await DatabaseHelper.getAnalysisInfo("iron");
    if (_currentType == AnalysisType.calcium) info = await DatabaseHelper.getAnalysisInfo("calcium");
    if (_currentType == AnalysisType.vitaminD) info = await DatabaseHelper.getAnalysisInfo("vitaminD");
    setState(() {
      _analyses.addAll(analyses);
    });
  }

  Future<void> _showRecommendationsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Выберите параметры анализа'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedAnalysis,
                    hint: Text('Выберите анализ'),
                    items: <String>['Железо', 'Кальций', 'Витамин D'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyle(color: Colors.black)),
                                );
                              }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value == "Железо") selectedAnalysis = "iron";
                        if (value == "Кальций") selectedAnalysis = "calcium";
                        if (value == "Витамин D") selectedAnalysis = "vitaminD";
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Text(selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                        : 'Выберите дату'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Закрыть'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Показать рекомендации'),
                  onPressed: selectedAnalysis != null && selectedDate != null
                      ? () {
                          final recommendations = <String>[recommendation];
                          showResultDialog(context, recommendations);
                        }: null,
                ),
              ],
            );
          },
        );
      },
    );
  }



  Future<void> showResultDialog(BuildContext context, List<String> recommendations) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Рекомендации'),
          content: SingleChildScrollView(
            child: Text(recommendations.join('\n')),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Условия конфиденциальности'),
          content: SingleChildScrollView(
            child: Text(
              '''
Ваше доверие к нашему мобильному медицинскому приложению "Персональный Медицинский Помощник" является нашим приоритетом. Мы стремимся обеспечить вашу конфиденциальность и безопасность данных. Данное условие конфиденциальности объясняет, как мы обрабатываем и защищаем ваши данные.

Сбор данных

Наше приложение собирает и хранит следующие виды данных на вашем устройстве:
- Медицинские данные (результаты анализов, медицинские рекомендации)
- Личные данные (например, ФИО, email)

Использование данных

Собранные данные используются исключительно для автоматического формирования медицинских рекомендаций и не передаются третьим лицам.

Хранение данных

Все данные хранятся локально на вашем устройстве в базе данных и не покидают его. Мы не передаём ваши данные ни в какие внешние сервисы или облачные хранилища.

Защита данных

Мы предпринимаем соответствующие меры для защиты данных, которые сохраняются на вашем устройстве, чтобы предотвратить несанкционированный доступ, изменение или удаление этих данных.

Изменение условий конфиденциальности

Мы можем время от времени обновлять наши условия конфиденциальности. В случае изменения условий вы будете уведомлены в приложении. Продолжение использования нашего приложения после обновлений означает ваше согласие с новыми условиями.

Если у вас возникли вопросы или сомнения относительно данных условий, пожалуйста, свяжитесь с нашей службой поддержки.

Дата вступления в силу: 10 июня 2024 года.

Спасибо за использование "Персонального Медицинского Помощника"!
              ''',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Профиль'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white, 
      ),
      body: Stack(
        children: [
          Positioned(
            top: -140,
            left: -80,
            child: Transform.rotate(
              angle: -25 * (pi / 180),
              child: Image.asset('assets/yellowDecoration.jpg', height: 380,),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -30,
            child: Transform.rotate(
              angle: -20 * (pi / 180),
              child: Image.asset('assets/greenDecoration.jpg', height: 300,),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200], 
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person),
                        ),
                        SizedBox(width: 16),
                        Text(
                          '${UserSession.currentUser?.fullName}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, LoginPage.routeName);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Кнопка "Мои данные"
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('Мои данные'),
                      ),
                      SizedBox(height: 16),
                      Divider(
                        color: Colors.grey[400], 
                        thickness: 1, 
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () {
                            _showRecommendationsDialog(context);
                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('Мои рекомендации'),
                      ),
                      SizedBox(height: 16),
                      Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                      SizedBox(height: 16),
                      // Кнопка "Настройки"
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('Настройки'),
                      ),
                      SizedBox(height: 16),
                      Divider(
                        color: Colors.grey[400], 
                        thickness: 1,
                      ),
                      SizedBox(height: 16),
                      // Кнопка "Условия конфиденциальности"
                      ElevatedButton(
                        onPressed: () {
                          _showPrivacyPolicy(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('Условия конфиденциальности'),
                      ),
                      SizedBox(height: 16),
                      Divider(
                        color: Colors.grey[400], 
                        thickness: 1,
                      ),
                      SizedBox(height: 16),
                      // Кнопка "Поддержка"
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), 
                          ),
                        ),
                        child: Text('Поддержка'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}