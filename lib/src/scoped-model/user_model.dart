import 'dart:convert';
import 'package:fun_to_do/helpers/urls_helper.dart';
import 'package:fun_to_do/src/models/user_model.dart';
import 'package:fun_to_do/src/service/user_info_sp.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends Model{
  List<UserInfo> _authtenticatedUserInfo = [];

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<UserInfo> get authtenticatedUserInfo{
    return List.from(_authtenticatedUserInfo);
  }


void updateUserInfo(String user_id, String name, String email) async{
    _isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(email +' : ' + name);
    var response = await http.post(UrlsHelper.updateUserInfoUrl, body: {'user_id': user_id, 'name': name, 'email': email});

    if(response.statusCode == 200){
      var jsonRes = json.decode(response.body);
      print('updateUser IT IS ${jsonRes}');
      
      if(jsonRes['error'] == '0'){
        
          prefs.setString("user_id", jsonRes['user_id']);
          prefs.setString("user_name", jsonRes["name"]);
          prefs.setString("user_email", jsonRes['email']);
          prefs.setString("user_token", jsonRes['token']);
        print('UPDATE USER INFO SUCCESS!!');
        
      }else{
        print('error is 1');
        
      }


      
    }else{
      print('updateUser ERORRR');
    }
  
  }


void updateUserPassword(String user_id, String password) async{
    _isLoading = true;
    notifyListeners();
    print(user_id +' : ' + password);
    var response = await http.post(UrlsHelper.updateUserPasswordUrl, body: {'user_id': user_id, 'password':password});

    if(response.statusCode == 200){
      var jsonRes = json.decode(response.body);
      print('updateUserPass IT IS ${jsonRes}');
      
      if(jsonRes['error'] == '0'){
        
        print('UPDATE USER INFO SUCCESS!!');
        
      }else{
        print('error is 1');
        
      }

    }else{
      print('updateUserPass ERORRR');
    }
 
  }
  void deleteUserAccount(String user_id) async{
    _isLoading = true;
    notifyListeners();
    print(user_id +' : ');
    var response = await http.post(UrlsHelper.deleteUserAccountUrl, body: {'user_id': user_id});

    if(response.statusCode == 200){
      var jsonRes = json.decode(response.body);
      print('updateUserPass IT IS ${jsonRes}');
      
      if(jsonRes['error'] == '0'){
        
        print('delete USER SUCCESS!!');
        
      }else{
        print('error is 1');
        
      }

    }else{
      print('delete account ERORRR');
    }
 
  }
}