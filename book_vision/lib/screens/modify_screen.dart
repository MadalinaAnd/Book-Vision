import 'dart:io';

import 'package:book_vision/model/book.dart';
import 'package:book_vision/services/book_service.dart';
import 'package:book_vision/utils/colors.dart';
import 'package:book_vision/utils/imput_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyScreen extends StatefulWidget {
  Book? book;
  BookService? bookService;

  ModifyScreen({
    Key? key,
    this.book,
    this.bookService,
  }) : super(key: key);

  Future<int> modifyBook(int id, String name, String author, String description, int numberOfPages, String genre, String publishingHouse) async {
    await Future.delayed(const Duration(milliseconds: 7));
    return bookService!.modify(id, name, author, description, numberOfPages, genre, publishingHouse);
  }

  @override
  _ModifyScreenState createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  var bookNameController = TextEditingController();
  var bookAuthorController = TextEditingController();
  var bookDescriptionController = TextEditingController();
  var bookPublishigHouseController = TextEditingController();
  var bookGenreController = TextEditingController();
  var bookNumberOfPagesController = TextEditingController();

  Future<int>? bookModified;

  void modify() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit a book'),
        content: const Text('Are you sure you want to edit a book?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Yes');
              try {
                setState(() {
                  bookModified = widget.modifyBook(widget.book!.id, bookNameController.text, bookAuthorController.text, bookDescriptionController.text, int.parse(bookNumberOfPagesController.text),
                      bookGenreController.text, bookPublishigHouseController.text);
                });

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Wait'),
                    actions: [
                      bookModified == null
                          ? const Text("Wait")
                          : FutureBuilder<int>(
                              future: bookModified,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      const Text("The book was modified.\nPres Ok to close."),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<BookModelItems>(context, listen: false).modify(widget.book!.id, bookNameController.text, bookAuthorController.text,
                                              int.parse(bookNumberOfPagesController.text), bookDescriptionController.text, bookGenreController.text, bookPublishigHouseController.text);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Column(children: [
                                    Text('Delivery error: ${snapshot.error.toString()}'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ]);
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              })
                    ],
                  ),
                );
              } on Exception catch (ex) {
                var error = ex.toString();
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Error'),
                    content: Text(error),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Ok'),
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'No');
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          title: const Text("Edit Book", style: TextStyle(fontSize: 24)),
          backgroundColor: ColorsUtils.darkPurple,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InputFields.inputField("Book name", "Book name", TextInputType.text, bookNameController, widget.book!.name),
              const SizedBox(height: 20.0),
              InputFields.inputField("Author Name", "Author Name", TextInputType.text, bookAuthorController, widget.book!.author),
              const SizedBox(height: 20.0),
              InputFields.inputField("Description", "Description", TextInputType.text, bookDescriptionController, widget.book!.description),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(child: InputFields.inputField("Publisher", "Publisher", TextInputType.text, bookPublishigHouseController, widget.book!.publishingHouse)),
                  const SizedBox(width: 20.0),
                  Expanded(child: InputFields.inputField("Genre", "Genre", TextInputType.text, bookGenreController, widget.book!.genre)),
                  const SizedBox(width: 20.0),
                  Expanded(child: InputFields.inputField("Pages", "Pages", TextInputType.text, bookNumberOfPagesController, widget.book!.numberPages.toString())),
                  const SizedBox(width: 20.0),
                ],
              ),
              const SizedBox(height: 40.0),
              TextButton(
                onPressed: () {
                  if (!ColorsUtils.internetConnection) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Warning!"),
                        content: const Text("Aplicatia nu este conectata la internet, modificarea va fi facuta local."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Ok');
                              modify();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    modify();
                  }
                },
                child: const Text(
                  "    Save    ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(ColorsUtils.purple),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
