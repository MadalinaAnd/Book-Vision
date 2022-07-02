import 'package:book_vision/model/book.dart';
import 'package:book_vision/screens/modify_screen.dart';
import 'package:book_vision/services/book_service.dart';
import 'package:book_vision/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookScreen extends StatefulWidget {
  Book? book;
  BookService? bookService;

  BookScreen({
    Key? key,
    this.book,
    this.bookService,
  }) : super(key: key);

  Future<int> deleteBook(int id) async {
    await Future.delayed(const Duration(milliseconds: 4));
    return bookService!.deleteBook(id);
  }

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  _BookScreenState();

  Future<int>? bookDeleted;

  void delete() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete a book'),
              content: const Text('Are you sure you want to delete this book?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Yes');
                    try {
                      setState(() {
                        bookDeleted = widget.deleteBook(widget.book!.id);
                      });

                      showDialog<String>(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Wait'),
                          actions: [
                            bookDeleted == null
                                ? const Text('Wait')
                                : FutureBuilder<int>(
                                    future: bookDeleted,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: [
                                            const Text("The book was deleted.\nPres Ok to close."),
                                            TextButton(
                                              onPressed: () {
                                                Provider.of<BookModelItems>(context, listen: false).delete(widget.book!.id);
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
                                    },
                                  ),
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
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var bo = Provider.of<BookModelItems>(context).findBookByID(widget.book!.id);
    if (bo != null) {
      widget.book = bo;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          title: Text(widget.book?.name as String, style: const TextStyle(fontSize: 24)),
          backgroundColor: ColorsUtils.darkPurple,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Name: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                        width: 170,
                        height: 35,
                        decoration: BoxDecoration(color: ColorsUtils.lightPurple, borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(widget.book!.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Author: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                        width: 170,
                        height: 35,
                        decoration: BoxDecoration(color: ColorsUtils.lightPurple, borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(widget.book!.author, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Genre", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Container(
                          width: 190,
                          height: 30,
                          decoration: BoxDecoration(color: ColorsUtils.lightPurple, borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(widget.book!.genre, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Pages", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Container(
                          width: 190,
                          height: 30,
                          decoration: BoxDecoration(color: ColorsUtils.lightPurple, borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  widget.book!.numberPages.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(color: ColorsUtils.lightPurple, borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(widget.book!.description, textAlign: TextAlign.start, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        height: 70,
        width: double.infinity,
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyScreen(book: widget.book, bookService: widget.bookService))).then((value) => setState(() {}));
              },
              child: Container(
                width: 140,
                height: 70,
                decoration: BoxDecoration(color: ColorsUtils.purple, borderRadius: BorderRadius.circular(30)),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text("       Edit", style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
              ),
            ),
            const SizedBox(width: 55),
            Container(
              decoration: BoxDecoration(color: ColorsUtils.purple, borderRadius: BorderRadius.circular(30)),
              child: TextButton.icon(
                  onPressed: () {
                    if (!ColorsUtils.internetConnection) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Warning!"),
                          content: const Text("Aplicatia nu este conectata la internet, stergerea va fi facuta local."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Ok');
                                delete();
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      delete();
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.white, size: 40),
                  label: const Text("Delete", style: TextStyle(color: Colors.white, fontSize: 24))),
            )
          ],
        ),
      ),
    );
  }
}
