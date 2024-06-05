import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Analysis {
  final DateTime date;
  final String type;
  final double value;

  Analysis({required this.date, required this.type, required this.value});

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'type': type,
      'value': value,
    };
  }
}

class DatabaseHelper {
  static Future<Database> openDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'analyses.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE analyses(date TEXT, type TEXT, value REAL, PRIMARY KEY (date, type))',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertAnalysis(Analysis analysis) async {
    final db = await openDb();
    db.insert('analyses', analysis.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Analysis>> getAnalyses() async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('analyses');
    return List.generate(maps.length, (i) {
      return Analysis(
        date: DateTime.parse(maps[i]['date']),
        type: maps[i]['type'],
        value: maps[i]['value'],
      );
    });
  }
}
