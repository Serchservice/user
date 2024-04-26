import 'package:user/library.dart';

class RepositoryService<T, K> {
  /// Create/Insert data given to the argument into the database
  Future<T> save(T item) async {
    throw SerchException(
      "This is a super class of repository. You should extend this class to its child classes."
    );
  }

  /// Reads data from the database based on the value based in the argument.
  T get() {
    throw SerchException(
      "This is a super class of repository. You should extend this class to its child classes."
    );
  }

  /// Get a single item from the table by id
  Future<Optional<T>> findById(K id) async {
    throw SerchException(
      "This is a super class of repository. You should extend this class to its child classes."
    );
  }

  /// Get every item in the table
  Future<List<T>> fetchAll() async {
    throw SerchException(
      "This is a super class of repository. You should extend this class to its child classes."
    );
  }

  /// Delete items from the table
  Future<void> deleteAll(List<T> items) async {
    throw SerchException(
      "This is a super class of repository. You should extend this class to its child classes."
    );
  }

  /// Delete data from database
  Future<Optional<T>> delete(T item) async {
    throw SerchException(
      "This is a super class of repository. You should extend this class to its child classes."
    );
  }
}