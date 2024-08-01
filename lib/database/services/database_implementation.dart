import 'package:get_storage/get_storage.dart';
import 'package:user/library.dart';

/// This class is the wrapper for the local database of the user.
class DatabaseImplementation implements DatabaseService {
  final GetStorage _box;
  DatabaseImplementation(String boxName) : _box = GetStorage(boxName);

  @override
  Future<void> write(String key, dynamic value) async => _box.write(key, value);

  @override
  T? read<T>(String key) => _box.read(key);

  @override
  Future<void> erase() async => _box.erase();

  @override
  Future<void> remove(String key) async => _box.remove(key);
}