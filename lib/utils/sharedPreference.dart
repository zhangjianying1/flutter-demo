import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences sp;
  static setString(String key, String value) async{
    print(sp);
    sp ??= await SharedPreferences.getInstance();
    sp.setString(key, value);
  }
  static getString(String key) async{
    sp = await SharedPreferences.getInstance();
    return  sp.getString(key);
  }
}