import 'package:my_books/models/book.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class BookService {
  Database db;
  BookService() {
    // _openConnect();
  }
  _openConnect() async {
    db = await openDatabase(join(await getDatabasesPath(), 'book.db'),
        version: 1, onCreate: (db, version) {
      db.execute(
          "CREATE TABLE book(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, status TEXT, pgs INTEGER, evaluation INTEGER )");
    });
  }

  closedConnection() {
    db.close();
  }

  Future<int> updateBook(int id, BookModel bookModel) async {
    try {
      if (db == null) {
        await _openConnect();
      }
      if (!db.isOpen) {
        await _openConnect();
      }
      var map = bookModel.toMap();
      return await db.update('book', map, where: "id = ?", whereArgs: [id]);
    } catch (ex) {
      throw ex;
    }
  }

  Future<int> delete(int id) async {
    try {
      if (db == null) {
        await _openConnect();
      }
      if (!db.isOpen) {
        await _openConnect();
      }
      return await db.delete('book', where: "id = ?", whereArgs: [id]);
    } catch (ex) {
      throw ex;
    }
  }

  Future<BookModel> getBook(int id) async {
    try {
      if (db == null) {
        await _openConnect();
      }
      if (!db.isOpen) {
        await _openConnect();
      }
      var book = await db.query('book', where: "id = ?", whereArgs: [id]);
      if (book.length > 0) {
        return BookModel.fromMap(book.first);
      }
      return null;
    } catch (ex) {
      throw ex;
    }
  }

  Future<int> inserTable(BookModel bookModel) async {
    try {
      if (db == null) {
        await _openConnect();
      }
      if (!db.isOpen) {
        await _openConnect();
      }
      var map = bookModel.toMap();
      return await db.insert('book', map);
    } catch (ex) {
      throw ex;
    }
  }

  Future<List<BookModel>> getAll() async {
    try {
      if (db == null) {
        await _openConnect();
      }
      if (!db.isOpen) {
        await _openConnect();
      }

      var books = await db.query('book');
      return books.isEmpty
          ? List<BookModel>()
          : List.generate(books.length, (i) {
              return BookModel(
                id: books[i]['id'],
                title: books[i]['title'],
                evaluation: books[i]['evaluation'],
                pgs: books[i]['pgs'],
                status: books[i]['status'],
              );
            });
    } on DatabaseException catch (ex) {
      var books = List<BookModel>();
      books.add(BookModel(
          id: 0, evaluation: 0, pgs: 0, status: "Não Lido", title: ""));
      return books;
    } on Exception catch (ex) {
      throw ex;
    }
  }
}
