import 'package:ws54_flutter_speedrun3/service/data_model.dart';
import 'package:ws54_flutter_speedrun3/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun3/service/sql_sevice.dart';

class Auth {
  static Future<Object> loginAuth(String account, String password) async {
    try {
      UserData userData =
          await UserDAO.getUserDataByAccountAndPassword(account, password);
      await SharedPref.setLoggedUserID(userData.id);
      print("get registered userdata!! ${userData.id}");
      return userData;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> hasAccountBeenRegistered(String account) async {
    try {
      UserData data = await UserDAO.getUserDataByAccount(account);
      print("account has been regstered. ${data.id}");
      return true;
    } catch (e) {
      print("account hasnt been regstered yet....");
      return false;
    }
  }

  static Future<bool> registerAuth(UserData userData) async {
    try {
      await UserDAO.addUserData(userData);
      await SharedPref.setLoggedUserID(userData.id);
      print("account regstered. ${userData.id}");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> logOut() async {
    await SharedPref.removeLoggedUserID();
    print("logged out and clean loged userID");
  }
}
