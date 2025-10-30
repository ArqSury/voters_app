import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = 'isLogin';
  static const String id = 'id';

  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

  static saveId(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(id, value);
  }

  static getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(id);
  }

  static removeId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(id);
  }
}
