import 'package:perfectpomodoro/model/event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EventsDatabase {
  static final EventsDatabase instance = EventsDatabase._init();

  static Database _database;

  EventsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('events.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    // final integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableEvents(
      ${EventFields.id} $idType,
      `${EventFields.title}` $textType,
      `${EventFields.description}` $textType,
      `${EventFields.from}` $textType,
      `${EventFields.to}` $textType,
      `${EventFields.isAllDay}` $boolType
    )
    ''');
  }

  Future<Event> create(Event event) async {
    final db = await instance.database;

    final id = await db.insert(tableEvents, event.toJson());

    return event.copy(id: id);
  }

  Future<int> update(Event event) async {
    final db = await instance.database;
    return await db.update(tableEvents, event.toJson(),
        where: '${EventFields.id} = ?', whereArgs: [event.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db
        .delete(tableEvents, where: '${EventFields.id} = ?', whereArgs: [id]);
  }

  // ignore: missing_return
  Future<Event> edit(Event oldEvent, Event newEvent) async {
    final db = await instance.database;
    await db.delete(tableEvents,
        where: '${EventFields.id} = ?', whereArgs: [oldEvent.id]);
    await db.insert(tableEvents, newEvent.toJson());
  }

  Future<List<Event>> readAllEvents() async {
    final db = await instance.database;

    final result = await db.query(tableEvents);

    return result.map((json) => Event.fromJson(json)).toList();
  }

  Future<Event> readEvent(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableEvents,
      columns: EventFields.values,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
