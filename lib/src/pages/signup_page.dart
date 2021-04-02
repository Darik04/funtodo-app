import 'dart:convert';

import 'package:fun_to_do/helpers/urls_helper.dart';
import 'package:fun_to_do/src/app.dart';
import 'package:fun_to_do/src/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _sendDataIsLoading;
  String _errorNotify;





void registerUser(String name, String email, String password) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(email +' : ' + password + ' : ' + name);
    var response = await http.post(UrlsHelper.registerUserUrl, body: {'name': name, 'email': email, 'password': password});

    if(response.statusCode == 200){
      var jsonRes = json.decode(response.body);
      print('auth IT IS ${jsonRes}');

      if(jsonRes['error'] == '0'){
        
          prefs.setString("user_id", jsonRes['user_id']);
          prefs.setString("user_name", jsonRes["name"]);
          prefs.setString("user_email", jsonRes['email']);
          prefs.setString("user_token", jsonRes['token']);
        print('REGISTER SUCCESS!!');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => FunToDo()));
        
      }else{
        print('error is 1');
        setState(() {
          _sendDataIsLoading = false;
          _errorNotify = 'Ошибка при регистраций!';
        });
      }
      
    }else{
      print('register ERORRR ${response.statusCode}');
      setState(() {
          _sendDataIsLoading = false;
          _errorNotify = 'Ошибка при регистраций!';
        });
    }

  }







  final formKey = GlobalKey<FormState>();



  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  

  bool _toggleVisibility = true;
  bool _toggleConfirmVisibility = true;
  
  Future<void> sendRegData() async {
    if(formKey.currentState.validate()){
      
      if(passwordController.text.trim() == passwordConfirmController.text.trim()){
        print('Me clicked!!!!!!!!!');
        registerUser(nameController.text.trim(), emailController.text.trim(), passwordController.text.trim());
        setState(() {
          _sendDataIsLoading = true;
          _errorNotify = null;

        });

      }else{
        setState(() {
          _errorNotify = 'Пароли не совпадают!';
        });
      }
        
        
      
      
      
    }
  }


  @override
  void initState() { 
    super.initState();
    _sendDataIsLoading = false;
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

  Widget _buildUsernameTextField() {
    return TextFormField(
            controller: nameController,
            validator: (val) {
          return val.length > 1 ? null : 'Введите ваше имя!';
        },
        decoration: InputDecoration(
          hintText: 'Ваше имя',
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

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
            controller: passwordConfirmController,
            validator: (val) {
          return val.length > 1 ? null : 'Введите повторный пароль!';
        },
        decoration: InputDecoration(
            hintText: 'Повторите пароль',
            hintStyle: TextStyle(color: Colors.grey[700], fontSize: 18.0),
            suffixIcon:
                IconButton(
                  onPressed: () {
                    setState(() {
                      _toggleConfirmVisibility = !_toggleConfirmVisibility;
                    });
                  }, 
                  icon: _toggleConfirmVisibility ? Icon(Icons.visibility_off) : Icon(Icons.visibility) 
                  )
              ),
        obscureText: _toggleConfirmVisibility,
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
            SizedBox(height: 50.0),

              Text(
                'Регистрация',
                style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40.0),
              
              Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                                      child: Column(
                      children: <Widget>[
                        _buildUsernameTextField(),
                        SizedBox(height: 20.0),
                        _buildEmailTextField(),
                        SizedBox(height: 20.0),
                        _buildPasswordTextField(),
                        SizedBox(height: 20.0),
                        _buildConfirmPasswordTextField()

                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: (){
                  sendRegData();
                },
                              child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                      child: _sendDataIsLoading == false ? Text(
                    'Зарегистрироваться',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ) : CircularProgressIndicator()),
                ),
              ),
              SizedBox(height: 5.0),
              _errorNotify != null ? Center(child: Text(_errorNotify, style: TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),),) : Container(),
              
            
              Divider(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Уже есть аккаунт?',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInPage()));
                    },
                                  child: Text(
                      'Войти',
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
