import 'package:flutter/material.dart';
import 'analyses_page.dart';
import 'database_helper.dart';


class AnalysisInput {
  String type;
  DateTime date;
  double value;

  AnalysisInput({
    required this.type,
    required this.date,
    required this.value,
  });
}


class AddAnalysisPage extends StatefulWidget {
  static const routeName = '/add-analysis';

  @override
  _AddAnalysisPageState createState() => _AddAnalysisPageState();
}

class _AddAnalysisPageState extends State<AddAnalysisPage> {
  List<AnalysisInput> inputs = [
    AnalysisInput(type: 'Железо', date: DateTime.now(), value: 0.0),
  ];

  void _addNewInput() {
    setState(() {
      inputs.add(AnalysisInput(type: 'Железо', date: DateTime.now(), value: 0.0));
    });
  }

  void _saveData() async {
    for (var input in inputs) {
      await DatabaseHelper.insertAnalysis(Analysis(
        id: UniqueKey().toString(),
        date: input.date,
        value: input.value,
        type: input.type,
        userId: UserSession.currentUser.userId
      ));
    }
    Navigator.pushReplacementNamed(context, AnalysisPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить анализы', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: inputs.length + 1,
                itemBuilder: (context, index) {
                  if (index == inputs.length) {
                    return Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                        ),
                        onPressed: _addNewInput,
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButton<String>(
                              value: inputs[index].type,
                              items: <String>['Железо', 'Кальций', 'Витамин D'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyle(color: Colors.black)),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  inputs[index].type = newValue!;
                                });
                              },
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: inputs[index].value.toString(),
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.black), 
                              onChanged: (newVal) {
                                if (newVal.isEmpty) {
                                  setState(() {
                                    inputs[index].value = 0.0;
                                  });
                                } else {
                                  setState(() {
                                    inputs[index].value = double.parse(newVal);
                                  });
                                }
                              },

                              decoration: InputDecoration(labelText: 'Показатель', labelStyle: TextStyle(color: Colors.black)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.calendar_today, color: Colors.black),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: inputs[index].date,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    inputs[index].date = pickedDate;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
            ),
            onPressed: _saveData,
            child: Text('Принять', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}