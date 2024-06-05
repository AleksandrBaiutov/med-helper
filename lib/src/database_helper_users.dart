import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final String userId;
  final String email;
  final String password;
  final String fullName;
  final DateTime subscriptionStatus;

  User({
    required this.userId,
    required this.email,
    required this.password,
    required this.fullName,
    required this.subscriptionStatus,
  });

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
class UserSession {
  static User? currentUser;
}

class DatabaseHelper {
  static Future<Database> openDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'users.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(userId TEXT PRIMARY KEY, email TEXT, password TEXT, fullName TEXT, subscriptionStatus TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertUser(User user) async {
    final db = await openDb();
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
