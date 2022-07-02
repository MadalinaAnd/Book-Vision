import 'dart:io';

import 'package:book_vision/model/book.dart';
import 'package:book_vision/model/book_item.dart';
import 'package:book_vision/screens/add_screen.dart';
import 'package:book_vision/services/book_service.dart';
import 'package:book_vision/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class BookMainScreen extends StatefulWidget {
  BookService? bookService;

  BookMainScreen({
    Key? key,
    this.bookService,
  }) : super(key: key);

  @override
  _BookMainScreenState createState() => _BookMainScreenState();
}

class _BookMainScreenState extends State<BookMainScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    Directory root = await getTemporaryDirectory();
    ColorsUtils.root = root.path;

    List<Book> books = await widget.bookService!.bookRepo!.getAll();
    var bookModelItems = books
        .map((data) => BookModelItem(
              id: data.id,
              name: data.name,
              author: data.author,
              numberPages: data.numberPages,
              description: data.description,
              genre: data.genre,
              publishingHouse: data.publishingHouse,
            ))
        .toList();
    Provider.of<BookModelItems>(context, listen: false).setAll(bookModelItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          title: const Text("Book Vision", style: TextStyle(fontSize: 24)),
          backgroundColor: ColorsUtils.darkPurple,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen(bookService: widget.bookService)));
        },
        child: const Icon(Icons.add, size: 50),
        backgroundColor: ColorsUtils.darkPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: Provider.of<BookModelItems>(context)
            .items
            .map((data) => BookItem(
                  data.id,
                  data.name,
                  data.author,
                  data.numberPages,
                  widget.bookService!,
                ))
            .toList(),
      ),
    );
  }
}
