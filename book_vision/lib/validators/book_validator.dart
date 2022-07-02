import 'package:book_vision/model/book.dart';

class BookValidator {
  String bookValidator(Book book) {
    String errors = "";

    if (book.name.isEmpty) {
      errors += "Book name is empty\n";
    }
    if (book.author.isEmpty) {
      errors += "Book author is empty\n";
    }
    if (book.description.isEmpty) {
      errors += "Book description is empty\n";
    }
    if (book.numberPages < 0) {
      errors += "Book number of Pages is empty\n";
    }
    if (book.genre.isEmpty) {
      errors += "Book genre is empty\n";
    }
    if (book.publishingHouse.isEmpty) {
      errors += "Book publishing house is empty\n";
    }

    return errors;
  }
}
