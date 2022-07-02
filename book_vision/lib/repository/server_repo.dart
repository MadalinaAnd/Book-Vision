import 'dart:convert';

import 'package:book_vision/model/book.dart';
import 'package:book_vision/repository/irepository.dart';
import 'package:book_vision/utils/colors.dart';
import 'package:http/http.dart' as http;

class BookRepositoryServer implements IRepository {
  @override
  Future<Book> add(Book book) async {
    final response = await http.post(Uri.parse(ColorsUtils.url + "/book"), body: book.toJson());
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var body = json.decode(response.body);
      return Book.fromJson(body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load book.');
    }
  }

  @override
  Future<int> delete(int id) async {
    final response = await http.delete(Uri.parse(ColorsUtils.url + "/book/" + id.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return 1;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete book.');
    }
  }

  @override
  Future<Book> findById(int id) async {
    final response = await http.get(Uri.parse(ColorsUtils.url + "/book/" + id.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var body = json.decode(response.body);
      return Book.fromJson(body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load book.');
    }
  }

  @override
  Future<List<Book>> getAll() async {
    List<Book> books = [];
    final response = await http.get(Uri.parse(ColorsUtils.url + "/books"));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      for (var item in body) {
        books.add(Book.fromJson(item));
      }
    } else {
      throw Exception('Failed to load album');
    }
    return books;
  }

  @override
  Future<int> modify(Book book) async {
    final response = await http.patch(Uri.parse(ColorsUtils.url + "/book"), body: book.toJsonWithId());
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return 1;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load book.');
    }
  }
}
