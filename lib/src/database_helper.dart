import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Analysis {
  final String id;
  final DateTime date;
  final String type;
  final double value;
  final String userId;

  Analysis({required this.id, required this.date, required this.type, required this.value, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'value': value,
      'user_id': userId,
    };
  }
}

class UserSession {
  static User currentUser = new User(email: "email", userId: "1", password: "password", subscriptionStatus: DateTime.now(), fullName: "full name");
}
class User {
  final String userId;
  final String email;
  final String password;
  final String fullName;
  final DateTime subscriptionStatus;

  User({required this.userId, required this.email, required this.password, required this.fullName, required this.subscriptionStatus});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'password': password,
      'fullName': fullName,
      'subscriptionStatus': subscriptionStatus.toIso8601String(),
    };
  }
}

class AnalysisInfo {
  final String type;
  final String ruType;
  final String measurementUnit;
  final double lowerBound;
  final double upperBound;
  final String lowValueAdvice;
  final String highValueAdvice;

  AnalysisInfo({required this.type, required this.ruType, required this.measurementUnit, required this.lowerBound, required this.upperBound, required this.lowValueAdvice, required this.highValueAdvice});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'ruType': ruType,
      'measurementUnit': measurementUnit,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
      'lowValueAdvice': lowValueAdvice,
      'highValueAdvice': highValueAdvice,
    };
  }
}

class Subscription {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String userId;

  Subscription({required this.id, required this.startDate, required this.endDate, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'user_id': userId,
    };
  }
}

class DatabaseHelper {
  static Future<Database> openDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'analyses.db'),
      onCreate: (db, version) {
        db.execute(
          '''
          CREATE TABLE analyses(
            id TEXT PRIMARY KEY, 
            date TEXT, 
            type TEXT, 
            value REAL, 
            user_id TEXT,
            FOREIGN KEY (type) REFERENCES analysis_info (type),
            FOREIGN KEY (user_id) REFERENCES users (userId)
          )
          '''
        );
        db.execute(
          '''
          CREATE TABLE users(
            userId TEXT PRIMARY KEY, 
            email TEXT, 
            password TEXT, 
            fullName TEXT, 
            subscriptionStatus TEXT
          )
          '''
        );
        db.execute(
          '''
          CREATE TABLE analysis_info(
            type TEXT PRIMARY KEY,
            ruType TEXT, 
            measurementUnit TEXT, 
            lowerBound REAL, 
            upperBound REAL, 
            lowValueAdvice TEXT, 
            highValueAdvice TEXT
          )
          '''
        );
        db.execute(
          '''
          CREATE TABLE subscriptions(
            id TEXT PRIMARY KEY, 
            startDate TEXT, 
            endDate TEXT, 
            user_id TEXT,
            FOREIGN KEY (user_id) REFERENCES users (userId)
          )
          '''
        );
        db.execute(
          '''
          CREATE TABLE analysestypesinfo(
            id TEXT PRIMARY KEY, 
            recommendedFrequency REAL
          )
          '''
        );
        db.execute(
          '''
          CREATE TABLE resultanalysis (
            id TEXT PRIMARY KEY, 
            startDate TEXT, 
            endDate TEXT, 
            changeOfValue TEXT,
          )
          '''
        );
        db.execute(
          '''
          CREATE TABLE recomendations (
            id TEXT PRIMARY KEY, 
            valueOfChangedValue TEXT, 
            recomendation TEXT, 
          )
          '''
        );
      },
      version: 1,
    );
  }

  static Future<void> insertAnalysis(Analysis analysis) async {
    final db = await openDb();
    await db.insert('analyses', analysis.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteAnalysis(String id) async {
    final db = await DatabaseHelper.openDb();
    await db.delete(
      'analyses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> insertUser(User user) async {
    final db = await openDb();
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertAnalysisInfo(AnalysisInfo analysisInfo) async {
    final db = await openDb();
    await db.insert('analysis_info', analysisInfo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertSubscription(Subscription subscription) async {
    final db = await openDb();
    await db.insert('subscriptions', subscription.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Analysis>> getAnalyses() async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('analyses');
    return List.generate(maps.length, (i) {
      return Analysis(
        id: maps[i]['id'],
        date: DateTime.parse(maps[i]['date']),
        type: maps[i]['type'],
        value: maps[i]['value'],
        userId: maps[i]['user_id'],
      );
    });
  }

  static Future<List<User>> getUsers() async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User(
        userId: maps[i]['userId'],
        email: maps[i]['email'],
        password: maps[i]['password'],
        fullName: maps[i]['fullName'],
        subscriptionStatus: DateTime.parse(maps[i]['subscriptionStatus']),
      );
    });
  }

  static Future<Map<String, dynamic>> getAnalysisInfo(String analysisType) async {
    final db = await DatabaseHelper.openDb();
    await db.delete('analysis_info');
    db.insert('analysis_info', {
      'type': 'iron',
      'ruType': 'железа',
      'measurementUnit': 'мкг/дл',
      'lowerBound': 2.0,
      'upperBound': 4.5,
      'lowValueAdvice': 'У вас слишком мало железа, съешьте яблоко и обратитесь к врачу',
      'highValueAdvice': 'У вас слишком много железа, уменьшите потребление и обратитесь к врачу'
    });
    await db.insert('analysis_info', {
      'type': 'calcium',
      'ruType': 'кальция',
      'measurementUnit': 'мг/дл',
      'lowerBound': 8.5,
      'upperBound': 10.2,
      'lowValueAdvice': 'У вас слишком мало кальция, употребляйте больше молочных продуктов и обратитесь к врачу',
      'highValueAdvice': 'У вас слишком много кальция, уменьшите потребление и обратитесь к врачу'
    });
    await db.insert('analysis_info', {
      'type': 'vitaminD',
      'ruType': 'витамина D',
      'measurementUnit': 'нг/мл',
      'lowerBound': 20.0,
      'upperBound': 50.0,
      'lowValueAdvice': 'У вас слишком мало витамина D, проведите больше времени на солнце и обратитесь к врачу',
      'highValueAdvice': 'У вас слишком много витамина D, уменьшите потребление добавок и обратитесь к врачу',
    });
    List<Map<String, dynamic>> result = await db.query(
      'analysis_info',
      where: 'type = ?',
      whereArgs: [analysisType],
    );
    return result.first;
  }

  static Future<User?> loginUser(String email, String password) async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User(
        userId: maps[0]['userId'],
        email: maps[0]['email'],
        password: maps[0]['password'],
        fullName: maps[0]['fullName'],
        subscriptionStatus: DateTime.parse(maps[0]['subscriptionStatus']),
      );
    }
    return null;
  }

  
  
}