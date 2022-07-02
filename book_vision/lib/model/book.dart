import 'dart:async';

class Book {
  int id = -1;
  String name = "";
  String author = "";
  String description = "";
  int numberPages = -1;
  String genre = "";
  String publishingHouse = "";

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.description,
    required this.numberPages,
    required this.genre,
    required this.publishingHouse,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'author': author,
      'description': description,
      'numberPages': numberPages,
      'genre': genre,
      'publishingHouse': publishingHouse,
    };
    return map;
  }

  Book.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    author = map['author'];
    description = map['description'];
    numberPages = map['numberPages'];
    genre = map['genre'];
    publishingHouse = map['publishingHouse'];
  }

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    author = json['author'];
    description = json['description'];
    numberPages = int.parse(json['numberPages']);
    genre = json['genre'];
    publishingHouse = json['publishingHouse'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'name': name,
      'author': author,
      'description': description,
      'numberPages': numberPages.toString(),
      'genre': genre,
      'publishingHouse': publishingHouse,
    };
    return map;
  }

  Map<String, dynamic> toJsonWithId() {
    var map = <String, dynamic>{
      'id': id.toString(),
      'name': name,
      'author': author,
      'description': description,
      'numberPages': numberPages.toString(),
      'genre': genre,
      'publishingHouse': publishingHouse,
    };
    return map;
  }
}
