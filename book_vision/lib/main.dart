import 'dart:async';

import 'package:book_vision/repository/book_repo_database.dart';
import 'package:book_vision/repository/server_repo.dart';
import 'package:book_vision/services/book_service.dart';
import 'package:book_vision/utils/colors.dart';
import 'package:book_vision/validators/book_validator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/book.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //static BookRepo bookRepo = BookRepo();
  static BookRepositoryDataBase bookRepoDB = BookRepositoryDataBase();
  static BookRepositoryServer bookRepo = BookRepositoryServer();
  static BookValidator bookValidator = BookValidator();
  static BookModelItems bookModelItems = BookModelItems();

  static BookService bookService = BookService(
    bookModelItems: bookModelItems,
    bookRepo: bookRepo,
    bookRepoDB: bookRepoDB,
    bookValidator: bookValidator,
  );
  const MyApp({Key? key}) : super(key: key);

  Future<void> copyInDB() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
      List<Book> booksDB = await bookService.bookRepoDB?.getAll();
      List<Book> booksServer = await bookService.bookRepo?.getAll();
      for (var item in booksDB) {
        bookRepoDB.delete(item.id);
      }
      for (var item in booksServer) {
        final b = await bookRepoDB.add(item);
      }
    } else {
      // ignore: avoid_print
      print("NU exista conexiune la net");
    }
  }

  void sync() async {
    List<Book> booksDB = await bookService.bookRepoDB?.getAll();
    List<Book> booksServer = await bookService.bookRepo?.getAll();

    var sizeDB = booksDB.length;
    var sizeServer = booksServer.length;

    for (int i = 0; i < sizeDB; i++) {
      for (int j = 0; j < sizeServer; j++) {
        //modify
        if (booksDB[i].id == booksServer[j].id &&
            (booksDB[i].name != booksServer[j].name ||
                booksDB[i].description != booksServer[j].description ||
                booksDB[i].author != booksServer[j].author ||
                booksDB[i].numberPages != booksServer[j].numberPages ||
                booksDB[i].genre != booksServer[j].genre ||
                booksDB[i].publishingHouse != booksServer[j].publishingHouse)) {
          bookService.bookRepo?.modify(booksDB[i]);
        }
      }
    }
    for (int i = 0; i < sizeDB; i++) {
      if (!booksServer.contains(booksDB[i])) {
        bookService.bookRepo?.add(booksDB[i]);
      }
    }
    for (int i = 0; i < sizeServer; i++) {
      if (!booksDB.contains(booksServer[i])) {
        bookService.bookRepo?.delete(booksServer[i].id);
      }
    }

    bookService.m();
  }

  @override
  Widget build(BuildContext context) {
    StreamSubscription<ConnectivityResult> subscription;
    copyInDB().then((value) {
      subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          // ignore: avoid_print
          print("Internet connection is inactive.");
          ColorsUtils.internetConnection = false;
          bookService.m();
        } else {
          // ignore: avoid_print
          print("Internet connection is active.");
          ColorsUtils.internetConnection = true;
          sync();
        }
      });
    });
    return ChangeNotifierProvider.value(
      value: BookModelItems(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BookMainScreen(bookService: bookService),
      ),
    );
  }
}
