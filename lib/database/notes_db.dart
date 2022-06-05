import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  NotesDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB('notes.db');
    return _database!;
  }

  Future<Database> _initializeDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableName(
${NoteFields.id} $idType,
${NoteFields.isImportant} $boolType,
${NoteFields.priorityLevel} $integerType,
${NoteFields.title} $textType,
${NoteFields.description} $textType,
${NoteFields.time} $textType
)
''');
  }

  //? Code for Inserting the Data / Record
  Future<Note> create(Note note) async {
    final db = await instance.database;
//?This method helps insert a map of [values] into the specified [table] and returns theid of the last inserted row.
    final id = await db.insert(tableName, note.toJson());
    return note.copy(id: id);
  }

  //? Code to Read a Single Record
  Future<Note> readNote(int id) async {
    final db = await instance.database;
//Select * from tableName where id = ?
    final maps = await db.query(tableName,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  //? Code to Read All the Records
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = '${NoteFields.time} ASC';
//final result = await db.rawQuery('SELECT * from $tableName order by $orderBy');
    final result = await db.query(tableName, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

//? Code to Update / Modify the Exsiting Data present within the Record
  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(tableName, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(tableName, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }

//Code to release the resources
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
