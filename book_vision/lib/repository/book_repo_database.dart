import 'package:book_vision/model/book.dart';
import 'package:book_vision/repository/irepository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class BookRepositoryDataBase implements IRepository {
  static Database? _database;
  static const String id = "id";
  static const String bookName = "name";
  static const String authorName = "author";
  static const String description = "description";
  static const String numberOfPages = "numberPages";
  static const String genre = "genre";
  static const String publishingHouse = "publishingHouse";
  static const String tableName = "books";
  static const String dataBaseName = "book7.db";

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initialiseDataBase();
    return _database;
  }

  initialiseDataBase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dataBaseName);
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY AUTOINCREMENT, $bookName TEXT, $authorName TEXT,$description TEXT,$numberOfPages INTEGER,$genre TEXT, $publishingHouse TEXT)",
    );
  }

  @override
  Future<Book> add(Book book) async {
    var dataClient = await database;
    book.id = await dataClient!.insert(tableName, book.toMap());
    return book;
  }

  @override
  Future<int> delete(int idc) async {
    var dataClient = await database;
    return await dataClient!.delete(tableName, where: '$id = ?', whereArgs: [idc]);
  }

  @override
  Future<Book> findById(int id) async {
    var dataClient = await database;
    String query = "SELECT * FROM " + tableName + " WHERE id = " + id.toString();
    var a = await dataClient!.rawQuery(query, null);
    var dataMap = Book.fromMap(a.first);
    return dataMap;
  }

  @override
  Future<List<Book>> getAll() async {
    var dataClient = await database;
    List<Map<String, dynamic>> maps = await dataClient!.query(tableName, columns: [id, bookName, authorName, description, numberOfPages, genre, publishingHouse]);

    List<Book> books = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        books.add(Book.fromMap(maps[i]));
      }
    }
    return books;
  }

  @override
  Future<int> modify(Book book) async {
    var dataClient = await database;
    return await dataClient!.update(tableName, book.toMap(), where: '$id = ?', whereArgs: [book.id]);
  }
}
