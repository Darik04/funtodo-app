import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoSP{
  static getUserToken() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("user_token");
      if(token == null){
        return null;
      }
      return token;
  }
  static getUserUser_id() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user_id = prefs.getString("user_id");
      if(user_id == null){
        return null;
      }
      return user_id;
  }
  static getUserUser_name() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user_name = prefs.getString("user_name");
      if(user_name == null){
        return null;
      }
      return user_name;
  }
  
  static getUserEmail() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user_name = prefs.getString("user_email");
      if(user_name == null){
        return null;
      }
      return user_name;
  }

  static removeUserAllInfo() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('user_id');
      prefs.remove('user_name');
      prefs.remove('user_email');
      prefs.remove('user_token');
  }
}
