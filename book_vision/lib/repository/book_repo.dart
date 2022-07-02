import 'package:book_vision/model/book.dart';

import 'irepository.dart';

class BookRepo implements IRepository {
  final List<Book> _books = [];

  @override
  void add(Book book) {
    _books.add(book);
  }

  @override
  void delete(int id) {
    _books.removeWhere((element) => element.id == id);
  }

  @override
  void modify(Book book) {
    var currentBook = _books.where((element) => element.id == book.id).first;
    currentBook.name = book.name;
    currentBook.author = book.author;
    currentBook.description = book.description;
    currentBook.numberPages = book.numberPages;
    currentBook.genre = book.genre;
    currentBook.publishingHouse = book.publishingHouse;
  }

  @override
  List<Book> getAll() {
    return _books;
  }

  @override
  Book findById(int id) {
    return _books.where((element) => element.id == id).first;
  }
}
