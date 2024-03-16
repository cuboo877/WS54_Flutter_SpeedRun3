import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'data_model.dart';

class UserDAO {
  static Database? database;
  static Future<Database> _initDataBase() async {
    database = await openDatabase(join(await getDatabasesPath(), "ws54.db"),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE users (id TEXT PRIMARY KEY, username TEXT, account TEXT, password TEXT, birthday TEXT)");
      await db.execute(
          "CREATE TABLE passwords (id TEXT PRIMARY KEY, userID TEXT, tag TEXT, url TEXT, login TEXT, password TEXT, isFav INTEGER, FOREIGN KEY (userID) REFERENCES users (id))");
    }, version: 1);
    return database!;
  }

  static Future<Database> getDBConnect() async {
    if (database != null) {
      return database!;
    } else {
      return await _initDataBase();
    }
  }

  static Future<UserData> getUserDataByUserID(String userID) async {
    final Database database = await getDBConnect();
    final List<Map<String, dynamic>> result =
        await database.query("users", where: "id = ?", whereArgs: [userID]);
    Map<String, dynamic> userData = result.first;
    return UserData(userData["id"], userData["username"], userData["account"],
        userData["password"], userData["birthday"]);
  }

  static Future<UserData> getUserDataByAccount(String account) async {
    final Database database = await getDBConnect();
    final List<Map<String, dynamic>> result = await database
        .query("users", where: "account = ?", whereArgs: [account]);
    Map<String, dynamic> userData = result.first;
    return UserData(userData["id"], userData["username"], userData["account"],
        userData["password"], userData["birthday"]);
  }

  static Future<UserData> getUserDataByAccountAndPassword(
      String account, String password) async {
    final Database database = await getDBConnect();
    final List<Map<String, dynamic>> result = await database.query("users",
        where: "account = ? AND password = ?", whereArgs: [account, password]);
    Map<String, dynamic> userData = result.first;
    return UserData(userData["id"], userData["username"], userData["account"],
        userData["password"], userData["birthday"]);
  }

  static Future<void> addUserData(UserData userData) async {
    final Database database = await getDBConnect();
    await database.insert("users", userData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateUserData(UserData userData) async {
    final Database database = await getDBConnect();
    await database.update("users", userData.toJson(),
        where: "id = ?",
        whereArgs: [userData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteserData(UserData userData) async {
    final Database database = await getDBConnect();
    await database.delete("users", where: "id = ?", whereArgs: [userData.id]);
  }
}

class PasswordDAO {
  static Future<List<PasswordData>> getPasswordListByUserID(
      String userID) async {
    final Database database = await UserDAO.getDBConnect();
    List<Map<String, dynamic>> result = await database
        .query("passwords", where: "userId = ?", whereArgs: [userID]);
    return List.generate(result.length, (index) {
      return PasswordData(
          result[index]["id"],
          result[index]["userID"],
          result[index]["tag"],
          result[index]["url"],
          result[index]["login"],
          result[index]["password"],
          result[index]["isFav"]);
    });
  }

  static Future<PasswordData> getPasswordByID(String id) async {
    final Database database = await UserDAO.getDBConnect();
    List<Map<String, dynamic>> maps =
        await database.query("passwords", where: "id = ?", whereArgs: [id]);
    Map<String, dynamic> result = maps.first;
    return PasswordData(result["id"], result["userID"], result["tag"],
        result["url"], result["login"], result["password"], result["isFav"]);
  }

  static Future<void> updatePasswordData(PasswordData passwordData) async {
    final Database database = await UserDAO.getDBConnect();
    await database.update("passwords", passwordData.toJson(),
        where: "id = ?",
        whereArgs: [passwordData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deletePasswordData(PasswordData passwordData) async {
    final Database database = await UserDAO.getDBConnect();
    await database
        .delete("passwords", where: "id = ?", whereArgs: [passwordData.id]);
  }

  static Future<void> addPasswordData(PasswordData passwordData) async {
    final Database database = await UserDAO.getDBConnect();
    await database.insert("passwords", passwordData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<PasswordData>> getPasswordListByCondition(
    String userID,
    String tag,
    String url,
    String login,
    String password,
    String id,
    bool hasFav,
    int isFav,
  ) async {
    String whereCondition = "userID = ?";
    List<dynamic> whereArgs = [userID];
    if (tag.trim().isNotEmpty) {
      whereCondition += "AND tag LIKE ?";
      whereArgs.add("%$tag%");
    }
    if (url.trim().isNotEmpty) {
      whereCondition += "AND url LIKE ?";
      whereArgs.add("%$url%");
    }
    if (login.trim().isNotEmpty) {
      whereCondition += "AND login LIKE ?";
      whereArgs.add("%$login%");
    }
    if (password.trim().isNotEmpty) {
      whereCondition += "AND password LIKE ?";
      whereArgs.add("%$password%");
    }
    if (id.trim().isNotEmpty) {
      whereCondition += "AND id LIKE ?";
      whereArgs.add("%$id%");
    }
    if (hasFav) {
      whereCondition += "AND isFav = ?";
      whereArgs.add(isFav);
    }

    final Database database = await UserDAO.getDBConnect();
    List<Map<String, dynamic>> result = await database.query("passwords",
        where: whereCondition, whereArgs: whereArgs);
    return List.generate(result.length, (index) {
      return PasswordData(
          result[index]["id"],
          result[index]["userID"],
          result[index]["tag"],
          result[index]["url"],
          result[index]["login"],
          result[index]["password"],
          result[index]["isFav"]);
    });
  }
}
