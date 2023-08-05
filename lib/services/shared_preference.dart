import 'package:shared_preferences/shared_preferences.dart';

// Shared preference is use to store local and users friendly data
// Shared Preferences allow you to save and retrieve data in the form of key-value pairs
class Sharedprefference {
  static String logedinkey = "Logedinkey";
  static String usernamekey = "username";
  static String useremailkey = "useremail";

  // *****************************************************
  // ********* Saving data throw sharedPreference ********
  static Future<bool> saveuselogein(bool userlogein) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(logedinkey, userlogein);
  }

  static Future<bool> saveusername(String username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(usernamekey, username);
  }

  static Future<bool?> saveuseremail(String useremail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(useremailkey, useremail);
  }

  // *****************************************************
  // ******** Getting data throw sharedPreference ********
  static Future<bool?> getuserlogein() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(logedinkey);
  }

  static Future<String?> getusername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(usernamekey);
  }

  static Future<String?> getuseremail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(useremailkey);
  }
}
