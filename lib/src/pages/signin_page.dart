import 'dart:convert';

import 'package:fun_to_do/helpers/urls_helper.dart';
import 'package:fun_to_do/src/app.dart';
import 'package:fun_to_do/src/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fun_to_do/src/scoped-model/main_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool _sendDataIsLoading;
  String _errorNotify;



  void authtenticatedUser(String email, String password) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(email +' : ' + password);
    var response = await http.post(UrlsHelper.authtenticatedUserUrl, body: {'email': email, 'password': password});

    if(response.statusCode == 200){
      var jsonRes = json.decode(response.body);
      print('auth IT IS ${jsonRes}');

      if(jsonRes['error'] == '0'){
        
          prefs.setString("user_id", jsonRes['user_id']);
          prefs.setString("user_name", jsonRes["name"]);
          prefs.setString("user_email", jsonRes['email']);
          prefs.setString("user_token", jsonRes['token']);

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => FunToDo()));
      }else{
        print('error is 1');
        setState(() {
          _sendDataIsLoading = false;
          _errorNotify = 'Пароль или email не совпадают!';
        });
      }

     
    }else{
      print('auth ERORRR');
    }
     

  }









  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sendDataIsLoading = false;
  }




  final formKey = GlobalKey<FormState>();
 


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  
  bool _toggleVisibility = true;

  MainModel mainModel = MainModel();

  Future<void> sendAuthData() async {
    if(formKey.currentState.validate()){
      
        authtenticatedUser(emailController.text.trim(), passwordController.text.trim());

        setState(() {
          _sendDataIsLoading = true;
        });
      
      
        
        
      
      
      
    }
  }

  Widget _buildEmailTextField() {
    return TextFormField(
        controller: emailController,
        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Не корректный e-mail";
                        },
        decoration: InputDecoration(
          hintText: 'Ваш email',
          hintStyle: TextStyle(color: Colors.grey[700], fontSize: 18.0),
        ),
      );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
        controller: passwordController,
            
        validator: (val) {
          return val.length > 5 ? null : 'Пароль не должен быть меньше 5 символов';
        },
        decoration: InputDecoration(
            
            hintText: 'Ваш пароль',
            hintStyle: TextStyle(color: Colors.grey[700], fontSize: 18.0),

            suffixIcon:
                IconButton(
                  onPressed: () {
                    setState(() {
                      _toggleVisibility = !_toggleVisibility;
                    });
                  }, 
                  icon: _toggleVisibility ? Icon(Icons.visibility_off) : Icon(Icons.visibility) 
                  )
              ),
        obscureText: _toggleVisibility,
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            
          body: ListView(
                      children: [Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 70.0),

              Text(
                'Вход',
                style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 90.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Забыли пароль?',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                                      child: Column(
                      children: <Widget>[
                        
                        _buildEmailTextField(),
                        SizedBox(height: 20.0),
                        _buildPasswordTextField()
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: (){
                  sendAuthData();
                  
                },
                              child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                      child: _sendDataIsLoading == false ? Text(
                    'Войти',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ) : CircularProgressIndicator()),
                ),
              ),
              SizedBox(height: 5.0),
              SizedBox(height: 5.0),
              _errorNotify != null ? Center(child: Text(_errorNotify, style: TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),),) : Container(),
              Divider(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Первый раз?',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignUpPage()));
                    },
                                  child: Text(
                      'Зарегистрируйтесь',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 80.0),

                ],
              )
            ],
        ),
      ),]
          )),
    );
  }
}
