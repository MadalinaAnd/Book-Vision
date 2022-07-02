import 'package:book_vision/model/book.dart';
import 'package:book_vision/services/book_service.dart';
import 'package:book_vision/utils/colors.dart';
import 'package:book_vision/utils/imput_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  BookService? bookService;

  AddScreen({Key? key, this.bookService}) : super(key: key);

  Future<Book> addBook(String name, String author, String description, int numberOfPages, String genre, String publishingHouse) async {
    await Future.delayed(const Duration(milliseconds: 7));
    return bookService!.addBook(name, author, description, numberOfPages, genre, publishingHouse);
  }

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  var bookNameController = TextEditingController();
  var bookAuthorController = TextEditingController();
  var bookDescriptionController = TextEditingController();
  var bookPublishigHouseController = TextEditingController();
  var bookGenreController = TextEditingController();
  var bookNumberOfPagesController = TextEditingController();

  Future<Book>? bookAdded;

  void add() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add a book'),
        content: const Text('Are you sure you want to add a book?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, "Yes");
              try {
                setState(() {
                  bookAdded = widget.addBook(bookNameController.text, bookAuthorController.text, bookDescriptionController.text, int.parse(bookNumberOfPagesController.text), bookGenreController.text,
                      bookPublishigHouseController.text);
                });
                showDialog<String>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Wait'),
                    actions: [
                      bookAdded == null
                          ? const Text('Wait')
                          : FutureBuilder<Book>(
                              future: bookAdded,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      const Text("The book was added successfully.\nPres Ok to close."),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<BookModelItems>(context, listen: false).add(snapshot.data!.id, bookNameController.text, bookAuthorController.text, bookDescriptionController.text,
                                              int.parse(bookNumberOfPagesController.text), bookGenreController.text, bookPublishigHouseController.text);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Column(children: [
                                    Text('Errors are :  ${snapshot.error.toString()}'),
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
                              },
                            )
                    ],
                  ),
                );
              } on Exception catch (ex) {
                var error = ex.toString();
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('An error has occurred'),
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
          )
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
          title: const Text("Add Book", style: TextStyle(fontSize: 24)),
          backgroundColor: ColorsUtils.darkPurple,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InputFields.inputField("Book name", "Book name", TextInputType.text, bookNameController, ""),
              const SizedBox(height: 20.0),
              InputFields.inputField("Author Name", "Author Name", TextInputType.text, bookAuthorController, ""),
              const SizedBox(height: 20.0),
              InputFields.inputField("Description", "Description", TextInputType.text, bookDescriptionController, ""),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(child: InputFields.inputField("Publisher", "Publisher", TextInputType.text, bookPublishigHouseController, "")),
                  const SizedBox(width: 20.0),
                  Expanded(child: InputFields.inputField("Genre", "Genre", TextInputType.text, bookGenreController, "")),
                  const SizedBox(width: 20.0),
                  Expanded(child: InputFields.inputField("Pages", "Pages", TextInputType.text, bookNumberOfPagesController, "")),
                  const SizedBox(width: 20.0),
                ],
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  if (!ColorsUtils.internetConnection) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Warning!"),
                        content: const Text("Aplicatia nu este conectata la internet, adaugarea va fi facuta local."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Ok');
                              add();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    add();
                  }
                },
                child: const Text("    Add    ", style: TextStyle(color: Colors.white, fontSize: 30)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(ColorsUtils.purple),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
