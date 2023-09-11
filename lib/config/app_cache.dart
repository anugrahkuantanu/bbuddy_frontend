import 'dart:convert';

import '../core/classes/cache_manager.dart';

// class AppCache {
//   Map<String, String>? udata;

//   // void doLogin(String username, String password) {
//   //   udata = {'user': username, 'pass': password};
//   //   Cache().saveData('auth_data', jsonEncode(udata));
//   // }

//   void doLogin(token, refreshToken) {
//     // Cache.saveData('auth_data', jsonEncode(loginData));

//       Cache.saveData('access_token', json.encode(token));
//       Cache.saveData('refresh_token', json.encode(refreshToken));
//   }

//   Future<Map<String, String>> auth() async {
//     var data = await Cache.readData('auth_data');
//     return udata = jsonDecode(data);
//   }

//   Future<bool> isLogin() async {
//     var data = await Cache.readData('auth_data');
//     if (data != null) {
//       return true;
//     }
//     return false;
//   }

//   void doLogout() {
//     Cache.deleteData('auth_data');
//   }

//   Future<bool> isLogout() async {
//     var data = await Cache.readData('auth_data');
//     if (data == null) {
//       return true;
//     }
//     return false;
//   }
// }

class AppCache {
  Map<String, String>? udata;

  void doLogin(token) {
    Cache.instance.store('access_token', json.encode(token));
  }
  
  void reLogin(refreshToken) {
    Cache.instance.store('refresh_token', json.encode(refreshToken));
  }

  Future<Map<String, String>> auth() async {
    var data = await Cache.instance.read('access_token');
    return udata = jsonDecode(data);
  }

  Future<bool> isLogin() async {
    var data = await Cache.instance.read('access_token');
    return data != null;
  }


  void doLogout() {
    Cache.instance.delete('access_token');
  }

  Future<bool> isLogout() async {
    var data = await Cache.instance.read('access_token');
    return data == null;
  }
}

