import 'package:flutter/foundation.dart';
import 'package:instagram_dumy/models/user_model.dart';
import 'package:instagram_dumy/services/database_services.dart';

class Userdataprovider extends ChangeNotifier {
  Usermodel? _usermodel;

  Usermodel get getuserdatamodel => _usermodel!;

  Future<Usermodel> refreshuserdata() async {
    Usermodel usermodel = await Databaseservice().gettingusersalldata();

    _usermodel = usermodel;
    notifyListeners();

    return usermodel;
  }
}
