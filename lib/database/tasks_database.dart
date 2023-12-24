import 'package:sqflite/sqflite.dart';
import 'package:tasktrack/models/task.dart';
import 'package:path/path.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();
  static Database? _database;
  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final identifierType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final booleanType = 'BOOLEAN NOT NULL';
    final stringType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tasksTable (
        ${TaskFields.id} $identifierType,
        ${TaskFields.name} $identifierType,
        ${TaskFields.description} $identifierType,
        ${TaskFields.category} $identifierType,
        ${TaskFields.priority} $identifierType,
        ${TaskFields.deadline} $stringType,
        ${TaskFields.status} $booleanType,
      )
    ''');
  }

  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final uniqueID = await db.insert(tasksTable, task.toJson());
    return task.createTaskCopy(id: uniqueID);
  }

  Future<Task> readTaskByID(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tasksTable,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    }
    else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    final tasks = await db.query(tasksTable);
    return tasks.map((json) => Task.fromJson(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db.update(
      tasksTable,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      tasksTable,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

}