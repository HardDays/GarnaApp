import 'package:garna/models/photo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PhotoDatabase {

  final _table = 'photos';

  Database _database;

  static final _instance = PhotoDatabase._internal();

  PhotoDatabase._internal();

  factory PhotoDatabase() {
    return _instance;
  }

  Future init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'photo_database_1.db'),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE photos(id INTEGER PRIMARY KEY, 
              contrast DOUBLE, exposure DOUBLE, whiteBalance DOUBLE, saturation DOUBLE,
              angle DOUBLE, skewX DOUBLE, skewY DOUBLE,
              cropLeftX DOUBLE, cropRightX DOUBLE, cropBottomY DOUBLE, cropTopY DOUBLE,
              originalPath TEXT, smallPath TEXT, mediumPath TEXT, filteredSmallPath TEXT, filteredOriginalPath TEXT
          )''',
        );
      },
      version: 1,
    );
  }


  Future<List<Photo>> all() async {
     try {
      final result = await _database.query(_table);
      return result.map((e) => Photo.fromJson(e)).toList();
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<Photo> create(Photo photo) async {
    try {
      final id = await _database.insert(_table, photo.toJson());
      final result = await _database.query(_table, where: 'id = $id');
      return Photo.fromJson(result.first);
    } catch (ex) {
      print(ex);
    }
  }

  Future<Photo> update(Photo photo) async {
    try {
      await _database.update(_table, photo.toJson(), where: 'id = ${photo.id}');
    } catch (ex) {
      print(ex);
    }
  }

  Future<Photo> remove(Photo photo) async {
    try {
      await _database.delete(_table, where: 'id = ${photo.id}');
    } catch (ex) {

    }
  }
  
}