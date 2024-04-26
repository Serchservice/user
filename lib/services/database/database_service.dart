abstract class DatabaseService {
  Future<void> write(String key, dynamic value);

  T? read<T>(String key);

  Future<void> erase();

  Future<void> remove(String key);
}