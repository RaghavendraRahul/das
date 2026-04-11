import '../../core/database/database.dart';

class UserRepository {
  final AppDatabase _db;

  UserRepository(this._db);

  Stream<List<User>> watchAllUsers() {
    return _db.select(_db.users).watch();
  }

  Future<void> addUser(UsersCompanion user) async {
    await _db.into(_db.users).insert(user);
  }

  Future<void> updateUser(UsersCompanion user) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(user.id.value)))
        .write(user);
  }

  Future<void> deleteUser(String userId) async {
    await (_db.delete(_db.users)..where((u) => u.id.equals(userId))).go();
  }
}
