// import 'package:contact/features/contact/models/contact_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
//
// class DatabaseHelper {
//   late Database _database;
//
//   Future<void> initializeDatabase() async {
//     String path = join(await getDatabasesPath(), 'contact.db');
//     _database = await openDatabase(path, version: 1, onCreate: _createDb);
//   }
//
//   Future<void> _createDb(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE contacts (
//         id INTEGER PRIMARY KEY,
//         name TEXT,
//         contactId TEXT,
//         phone TEXT,
//         creationDate INTEGER
//       )
//     ''');
//   }
//
//   Future<int> insertContact(ContactModel contact) async {
//     return await _database.insert('contacts', contact.toJson());
//   }
//
//   Future<List<ContactModel>> fetchAllContacts() async {
//     final List<Map<String, dynamic>> maps = await _database.query('contacts');
//     return List.generate(maps.length, (i) {
//       return ContactModel(
//         id: maps[i]['id'],
//         name: maps[i]['name'],
//         creationDate: maps[i]['creationDate'], phone: maps[i]['phone'], contactId: maps[i]['contactId'],
//       );
//     });
//   }
//
//   Future<void> deleteExpiredContacts() async {
//     int currentTime = DateTime.now().millisecondsSinceEpoch;
//     await _database.delete('contacts', where: 'creationDate <= ?', whereArgs: [currentTime - 30 * 24 * 60 * 60 * 1000]);
//   }
// }


import 'package:contact/features/contact/models/contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();

  LocalDatabase._init();

  factory LocalDatabase() {
    return getInstance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("student.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER DEFAULT 0";

    await db.execute('''
    CREATE TABLE ${ContactModelFields.tableName} (
    ${ContactModelFields.id} $idType,
    ${ContactModelFields.name} $textType,
    ${ContactModelFields.phone} $textType,
    ${ContactModelFields.creationDate} $intType
    )
    ''');

    debugPrint("-------DB----------CREATED---------");
  }

  static Future<void> deleteOldContact() async {
    final Database db = await getInstance.database;

    final thirtyDaysAgo = DateTime.now().subtract(const Duration(minutes: 10)).millisecondsSinceEpoch;

    await db.delete(
      ContactModelFields.tableName,
      where: '${ContactModelFields.creationDate} < ?',
      whereArgs: [thirtyDaysAgo],
    );
  }

  static Future<ContactModelSql> insertContact(
      ContactModelSql studentModel) async {
    final db = await getInstance.database;
    final int id = await db.insert(
        ContactModelFields.tableName, studentModel.toJson());
    print('qoshildi');
    return studentModel.copyWith(id: id);
  }

  static Future<List<ContactModelSql>> getAllContact() async {
    List<ContactModelSql> allStudent = [];
    final db = await getInstance.database;
    allStudent = (await db.query(ContactModelFields.tableName))
        .map((e) => ContactModelSql.fromJson(e))
        .toList();
    return allStudent;
  }

 static Future<void> deleteExpiredContacts() async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    await _database?.delete(ContactModelFields.tableName, where: '${ContactModelFields.creationDate} <= ?', whereArgs: [currentTime - 1 * 24 * 60 * 60 * 1000]);
  }


  static updateStudent({required ContactModelSql studentModel}) async {
    final db = await getInstance.database;
    db.update(
      ContactModelFields.tableName,
      studentModel.toJson(),
      where: "${ContactModelFields.id} = ?",
      whereArgs: [studentModel.id],
    );
  }

  static deleteTable()async{
    final db = await getInstance.database;
    await db.execute('DROP TABLE IF EXISTS ${ContactModelFields.tableName}');
    print('Delete table');
  }


  static Future<void> autoOpenReferences() async {
    final db = await getInstance.database;

    // Calculate the timestamp for 30 days ago
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch;

    // Retrieve references that are not opened and created more than 30 days ago
    final List<Map<String, dynamic>> references = await db.query(
      ContactModelFields.tableName,
      where: 'isOpened = 0 AND ${ContactModelFields.creationDate} < ?',
      whereArgs: [thirtyDaysAgo],
    );

    // Update the isOpened flag for these references
    for (Map<String, dynamic> reference in references) {
      await db.update(
        ContactModelFields.tableName,
        {'isOpened': 1}, // Set isOpened to 1 (opened)
        where: '${ContactModelFields.id} = ?',
        whereArgs: [reference['id']],
      );
    }
  }

  static Future<int> deleteStudent(int id) async {
    final db = await getInstance.database;
    int count = await db.delete(
      ContactModelFields.tableName,
      where: "${ContactModelFields.id} = ?",
      whereArgs: [id],
    );
    return count;
  }

}