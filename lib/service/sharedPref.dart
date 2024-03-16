import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<void> setLoggedUserID(String userID) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("logged userID");
    pref.setString("logged userID", userID);
  }

  static Future<String> getLoggedUserID() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("logged userID") ?? "";
  }

  static Future<void> removeLoggedUserID() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("logged userID");
  }
}
