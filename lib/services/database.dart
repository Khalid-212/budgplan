import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/data_model.dart';

class FinanceDataBase {
  static final FinanceDataBase instance = FinanceDataBase._init();

  static Database? _database;
  FinanceDataBase._init();

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('finance.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final amount = 'INTEGER NOT NULL';
    final date = 'TEXT NOT NULL';
    final category = 'TEXT NOT NULL';
    final reason = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableFinance(
        ${financeFields.id} $idType,
        ${financeFields.amount} $amount,
        ${financeFields.date} $date,
        ${financeFields.category} $category,
        ${financeFields.reason} $reason
      )
''');
  }

  Future<Data> create(Data data) async {
    final db = await instance.database;

    // final json = data.toJson();
    // final columns =
    //     '${financeFields.amount}, ${financeFields.date}, ${financeFields.category}';

    // final values = '${data.amount}, ${data.date}, ${data.category}';

    // final id =
    //     await db!.rawInsert('INSERT INTO table_name($columns) VALUER($values)');

    final id = await db!.insert(tableFinance, data.toJson());
    return data.copy(id: id);
  }

  Future<List<Data>> readAllData() async {
    final db = await instance.database;
    final orderBy = '${financeFields.date} DESC';
    final result = await db!.query(tableFinance, orderBy: orderBy);
    return result.map((json) => Data.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db!.delete(tableFinance,
        where: '${financeFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db?.close();
  }
}

// user database
class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();

  static Database? _database;
  UserDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('user.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final balance = 'INTEGER NOT NULL';
    final name = 'TEXT NOT NULL';
    final phonenumber = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableUser(
        ${userFields.id} $idType,
        ${userFields.balance} $balance,
        ${userFields.name} $name,
        ${userFields.phonenumber} $phonenumber
      )
    ''');
  }

  Future<UserData> create(UserData userData) async {
    final db = await instance.database;
    final id = await db!.insert(tableUser, userData.toJson());
    return userData.copy(id: id);
  }

  Future<List<Data>> readUserAllData() async {
    final db = await instance.database;
    final orderBy = '${userFields.id} DESC';
    final result = await db!.query(tableUser, orderBy: orderBy);
    return result.map((json) => Data.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db!
        .delete(tableUser, where: '${userFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db?.close();
  }
}
