import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('women_security.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    print("🔥 Database Path: $path"); // Debugging statement ✅

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE friend_list (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL
      );
    ''');
  }

  Future<void> exportDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final databaseFile = File(join(dbPath, 'women_security.db'));

      if (!await databaseFile.exists()) {
        print("❌ Database file not found: ${databaseFile.path}");
        return;
      }

      final publicDir = Directory('/storage/emulated/0/Download/');
      if (!publicDir.existsSync()) publicDir.createSync(recursive: true);

      final newPath = join(publicDir.path, 'women_security.db');
      await databaseFile.copy(newPath);

      print("✅ Database copied to: $newPath");
    } catch (e) {
      print("❌ Error copying database: $e");
    }
  }

  // ✅ Fetch user data
  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final result = await db.query('users', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    print("📌 All Users in DB: $result");
    return result;
  }

  // ✅ Insert User
  Future<void> insertUser(String name, String email) async {
    final db = await database;
    await db.insert(
      'users',
      {'name': name, 'email': email},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ Insert a Friend for SOS
  Future<void> insertFriend(String name, String phone) async {
    final db = await database;
    await db.insert(
      'friend_list',
      {'name': name, 'phone': phone},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ Fetch Friend List
  Future<List<Map<String, dynamic>>> getAllFriends() async {
    final db = await database;
    return await db.query('friend_list');
  }

  // ✅ Remove a friend from the friend list
  Future<int> deleteFriend(int id) async {
    final db = await database;
    print("🗑️ Attempting to delete friend with ID: $id");

    int result = await db.delete(
      'friend_list', // ✅ Corrected table name
      where: 'id = ?',
      whereArgs: [id],
    );

    // 👇 Add this block
    if (result == 0) {
      print("❌ No friend found with ID: $id");
    } else {
      print("✅ Friend deleted successfully");
    }

    return result;
  }

  Future<List<String>> getFriendPhoneNumbers() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('friend_list');
    return result.map((e) => e['phone'].toString()).toList();
  }

  Future<void> debugPrintContacts() async {
    final db = await database;
    final contacts = await db.query('friend_list');
    print("📌 Stored Contacts in Database: $contacts");
  }
}
