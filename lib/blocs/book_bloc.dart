import 'dart:async';
import 'dart:math';

import 'package:my_books/models/book.model.dart';
import 'package:my_books/services/book.service.dart';
import 'package:lipsum/lipsum.dart' as lipsum;

class BookBloc {
  final _bookBloc = StreamController<List<BookModel>>();
  //.seeded(BookModel(
  //  id: 0, evaluation: false, pgs: 0, status: Status.naoLido, title: ""));

  get out => _bookBloc.stream;

  Sink<List<BookModel>> get enter => _bookBloc.sink;

  // List<BookModel> get value => _bookBloc.value;

  void getAll() async {
    final bookService = new BookService();
    var books = await bookService.getAll();
    _bookBloc.add(books);
  }

  void addBook(BookModel bookModel) async {
    final bookService = new BookService();
    await bookService.inserTable(bookModel);
  }

  void updateBookEvaluation(int id, int eval) async {
    final bookService = new BookService();
    var book = await getBook(id);
    book.evaluation = eval;
    await bookService.updateBook(id, book);
  }

  void updateBookStatus(int id, String status) async {
    final bookService = new BookService();
    var book = await getBook(id);
    book.status = status;
    await bookService.updateBook(id, book);
  }

  Future<BookModel> getBook(int id) async {
    final bookService = new BookService();
    return await bookService.getBook(id);
  }

  Future<bool> delete(int id) async {
    final bookService = new BookService();
    var result = await bookService.delete(id);
    if (result > 0) {
      return true;
    } else {
      return true;
    }
  }

  Future<String> generatePgs() async {
    var random = Random();
    var pgs = random.nextInt(300);
    while (pgs < 100) {
      pgs = random.nextInt(300);
    }
    await Future.delayed(Duration(seconds: random.nextInt(4)));
    return Future.value(
        lipsum.createSentence(sentenceLength: pgs, numSentences: pgs));
  }

  void dispose() {
    _bookBloc.close();
  }
}
