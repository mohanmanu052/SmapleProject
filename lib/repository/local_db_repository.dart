import 'package:sample/model/user_model.dart';
import 'package:sample/utils/database_utils.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryUsers {
  Future<Database> _getDatabase() async {
    return openDatabase(
      DATABASE_NAME,
      onCreate: (db, version) {
        return db.execute(CREATE_TABLE_USER);
      },
      version: 1,
    );
  }

  Future<String> countRegistry() async {
    try {
      final Database db = await _getDatabase();
      final data = await db.rawQuery('SELECT count(*) as total FROM Users');
      return data[0]['total'].toString();
    } catch (e) {
      print(e);
      return '-1';
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final Database db = await _getDatabase();
      final List<Map<String, dynamic>> maps =
          await db.query('Users', orderBy: 'id DESC');
      return List.generate(maps.length, (i) {
        return UserModel.fromJson(maps[i]);
      });
    } catch (e) {
      print(e);
      return <UserModel>[];
    }
  }

  Future insertUsers(UserModel Users) async {
    try {
      final Database db = await _getDatabase();
      await db.insert('Users', Users.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future updateUsers(UserModel Users) async {
    try {
      final Database db = await _getDatabase();
      await db.update('Users', Users.toJson(),
          where: 'id = ?', whereArgs: [Users.id]);
    } catch (e) {
      print(e);
    }
  }

  Future deleteUsers(int id) async {
    try {
      final Database db = await _getDatabase();
      await db.delete('Users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print(e);
    }
  }

  Future clearTable() async {
    try {
      final Database db = await _getDatabase();
      await db.rawQuery('DELETE FROM Users');
    } catch (e) {
      print(e);
    }
  }
}
