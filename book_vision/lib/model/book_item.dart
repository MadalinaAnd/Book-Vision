import 'package:book_vision/screens/book_screen.dart';
import 'package:book_vision/services/book_service.dart';
import 'package:book_vision/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookItem extends StatefulWidget {
  final int id;
  final String bookName;
  final String bookAuthor;
  final int bookNameOfPages;
  BookService bookService;

  BookItem(this.id, this.bookName, this.bookAuthor, this.bookNameOfPages, this.bookService, {Key? key}) : super(key: key);

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> defaultImage = const AssetImage("assets/images/book1.jpg");

    return SizedBox(
      height: 120,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookScreen(
                book: Provider.of<BookModelItems>(context, listen: false).findBookByID(widget.id),
                bookService: widget.bookService,
              ),
            ),
          ).then((value) => setState(() {})).then((value) => setState(() {}));
        },
        child: Row(
          children: [
            Container(
              width: 80,
              height: 90,
              decoration: BoxDecoration(
                image: DecorationImage(image: defaultImage, fit: BoxFit.cover),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(9), bottomLeft: Radius.circular(9)),
              ),
            ),
            Container(
              width: 270,
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text("     " + widget.bookName, style: const TextStyle(fontSize: 20)),
                  Text("      " + widget.bookAuthor, style: const TextStyle(fontSize: 16)),
                  Text("       " + widget.bookNameOfPages.toString() + " pages", style: const TextStyle(fontSize: 14)),
                ],
              ),
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(9), bottomRight: Radius.circular(9)), color: ColorsUtils.lightPurple),
            )
          ],
        ),
      ),
    );
  }
}
