import 'package:book_vision/model/book.dart';

abstract class IRepository<T1, T2, T3> {
  T2? add(Book book) {}
  T3? delete(int id) {}
  T3? modify(Book book) {}
  T1? getAll() {}
  T2? findById(int id) {}
}
