import 'package:book_vision/model/book.dart';
import 'package:book_vision/repository/irepository.dart';
import 'package:book_vision/utils/colors.dart';
import 'package:book_vision/validators/book_validator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class BookModelItem {
  int id;
  String name;
  String author;
  String description;
  int numberPages;
  String genre;
  String publishingHouse;
  Image image = Image.asset("assets/images/book1.jpg");

  BookModelItem({
    required this.id,
    required this.name,
    required this.author,
    required this.description,
    required this.numberPages,
    required this.genre,
    required this.publishingHouse,
  });
}

class BookModelItems extends ChangeNotifier {
  List<BookModelItem> items = [];

  void add(int id, String name, String author, String description, int numberOfPages, String genre, String publishingHouse) {
    items.add(BookModelItem(id: id, name: name, author: author, numberPages: numberOfPages, description: description, genre: genre, publishingHouse: publishingHouse));
    notifyListeners();
  }

  void delete(int id) {
    items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void modify(int id, String name, String author, int numberOfPages, String description, String genre, String publishingHouse) {
    var item = items.where((element) => element.id == id).first;
    item.name = name;
    item.author = author;
    item.numberPages = numberOfPages;
    item.description = description;
    item.genre = genre;
    item.publishingHouse = publishingHouse;

    notifyListeners();
  }

  Book? findBookByID(int id) {
    try {
      var ite = items.where((element) => element.id == id);
      BookModelItem? item = null;
      if (ite.isNotEmpty) {
        item = ite.first;
      }

      if (item == null) {
        return null;
      } else {
        return Book(
          id: item.id,
          author: item.author,
          description: item.description,
          genre: item.genre,
          name: item.name,
          numberPages: item.numberPages,
          publishingHouse: item.publishingHouse,
        );
      }
    } on Exception {
      return null;
    }
  }

  List<BookModelItem> getAll() {
    notifyListeners();
    return items;
  }

  void setAll(List<BookModelItem> books) {
    items.clear();
    items = books;
    notifyListeners();
  }
}

class BookService with ChangeNotifier {
  IRepository? bookRepo;
  IRepository? bookRepoDB;
  BookValidator? bookValidator;
  BookModelItems? bookModelItems;

  BookService({this.bookModelItems, this.bookRepo, this.bookRepoDB, this.bookValidator});

  void m() async {
    List<Book> books = await getAllBook();

    var bookModelItemsd = books
        .map((data) => BookModelItem(
              id: data.id,
              name: data.name,
              author: data.author,
              description: data.description,
              numberPages: data.numberPages,
              genre: data.genre,
              publishingHouse: data.publishingHouse,
            ))
        .toList();
    bookModelItems?.setAll(bookModelItemsd);
  }

  Future<Book> addBook(String name, String author, String description, int numberOfPages, String genre, String publishingHouse) {
    var book = Book(id: -1, name: name, author: author, description: description, numberPages: numberOfPages, genre: genre, publishingHouse: publishingHouse);
    var errors = bookValidator!.bookValidator(book);

    if (errors == "") {
      if (ColorsUtils.internetConnection) {
        print("Add in Server");
        bookRepoDB!.add(book);
        return bookRepo!.add(book);
      } else {
        print("Add in DB");
        return bookRepoDB!.add(book);
      }
    } else {
      throw Exception(errors);
    }
  }

  Future<int> deleteBook(int id) {
    if (ColorsUtils.internetConnection) {
      print("Delete in server: " + id.toString());
      bookRepoDB!.delete(id);
      return bookRepo!.delete(id);
    } else {
      print("Delete in DB: " + id.toString());
      return bookRepoDB!.delete(id);
    }
  }

  Future<int> modify(int id, String name, String author, String description, int numberOfPages, String genre, String publishingHouse) {
    var book = Book(id: id, name: name, author: author, description: description, numberPages: numberOfPages, genre: genre, publishingHouse: publishingHouse);

    var errors = bookValidator!.bookValidator(book);
    if (errors == "") {
      if (ColorsUtils.internetConnection) {
        print("Modify in Server");
        bookRepoDB!.modify(book);
        return bookRepo!.modify(book);
      } else {
        print("Modify in DB");
        return bookRepoDB!.modify(book);
      }
    } else {
      throw Exception(errors);
    }
  }

  Future<List<Book>> getAllBook() {
    if (ColorsUtils.internetConnection) {
      print("GetAll in server");
      return bookRepo!.getAll();
    } else {
      print("GetAll in DB");
      return bookRepoDB!.getAll();
    }
  }

  Future<Book> findBookById(int id) {
    if (ColorsUtils.internetConnection) {
      return bookRepo!.findById(id);
    } else {
      return bookRepoDB!.findById(id);
    }
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
