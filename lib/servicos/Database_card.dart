import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cards.db');
    return await openDatabase(
      path,
      version: 2, // Incremented version number
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE cards("
          "id INTEGER PRIMARY KEY, "
          "cardNumber TEXT, "
          "expiryDate TEXT, "
          "cvv TEXT, "
          "cardholderName TEXT, "
          "cpf TEXT, "
          "nickname TEXT"
          ")",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute("ALTER TABLE cards ADD COLUMN expiryDate TEXT");
          db.execute("ALTER TABLE cards ADD COLUMN cvv TEXT");
          db.execute("ALTER TABLE cards ADD COLUMN cardholderName TEXT");
          db.execute("ALTER TABLE cards ADD COLUMN cpf TEXT");
          db.execute("ALTER TABLE cards ADD COLUMN nickname TEXT");
        }
      },
    );
  }

  Future<void> insertCard(Map<String, dynamic> card) async {
    final db = await database;
    await db.insert('cards', card,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCard(int id) async {
    final db = await database;
    await db.delete('cards', where: "id = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getCards() async {
    final db = await database;
    return await db.query('cards');
  }
}
