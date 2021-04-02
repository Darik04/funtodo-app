import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fun_to_do/helpers/urls_helper.dart';
import 'package:fun_to_do/src/scoped-model/main_model.dart';
import 'package:fun_to_do/src/service/theme_mode_sp.dart';
import 'package:fun_to_do/src/pages/signin_page.dart';
import 'package:fun_to_do/src/service/user_info_sp.dart';
import 'package:http/http.dart' as http;

import '../app.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  getUser_nameSP() async {
    String user_name = await UserInfoSP.getUserUser_name();
    return user_name;
  }

  getUser_idSP() async {
    String user_id = await UserInfoSP.getUserUser_id();
    print('getUser_id profilePage : ${user_id}');
    return user_id;
  }
  getUser_emailSP() async {
    String user_email = await UserInfoSP.getUserEmail();
    print('getuser_email profilePage : ${user_email}');
    return user_email;
  }
  

  getSelect() async {
    bool themeMode = await ThemeModeSP.getBoolThemeMode();

    if (themeMode == true) {
      return isSelected = [true, false];
    } else if (themeMode == false) {
      return isSelected = [false, true];
    }
  }

  final listTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600);
  MainModel mainModel = MainModel();
  List<bool> isSelected;
  bool _isEdit;
  bool _isLoading;
  bool _isDelete;
  int _isEditPassword;
  String user_name;
  String user_email;
  String user_id;

  String _errorNotify;


  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController password2Controller = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();


  bool _toggleVisibility;
  bool _toggleVisibility2;

  @override
  void initState() {
    _toggleVisibility = true;
    _toggleVisibility2 = true;
    super.initState();
    getSelect().then((response) {
      setState(() {
        isSelected = response;
      });
    });
    getUser_nameSP().then((response) {
      setState(() {
        user_name = response;
      });
    });
    getUser_idSP().then((response) {
      setState(() {
        user_id = response;
      });
    });
    getUser_emailSP().then((response) {
      setState(() {
        user_email = response;
      });
    });
    _isEdit = false;
    _isEditPassword = 0;
    _isLoading = false;
    _isDelete = false;
  }




void checkUserPassword(String user_id, String password) async{


    print(user_id +' : ' + password);
    var response = await http.post(UrlsHelper.checkUserPasswordUrl, body: {'user_id': user_id, 'password': password});

    if(response.statusCode == 200){
      var jsonRes = json.decode(response.body);
      print('checkPasss IT IS ${jsonRes}');

      if(jsonRes['error'] == '0'){
        
        setState(() {
            _errorNotify = null;
            password2Controller.text = '';
            passwordConfirmController.text = '';
          _isEditPassword = 2;
          _isLoading = false;
        });
        
      }else{
        print('error is 1');
        setState(() {
          _errorNotify = 'Не верный пароль!';
          _isLoading = false;
        });
      }
   
      
    }else{
      print('checkPasss ERORRR');
    }

  }











  void sendUpdateUserInfo() {
    if (formKey.currentState.validate()) {
      mainModel.updateUserInfo(user_id, nameController.text.trim(), emailController.text.trim());
      setState(() {
        _isEdit = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Успешно изменено!"),
      ));
    }
  }


  void sendCheckUserPassword(){
    if(formKey2.currentState.validate()){
      checkUserPassword(user_id, passwordController.text.trim());
      setState(() {
        
        passwordController.text = '';
        _isLoading = true;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Подождите идет проверка пароля!"),
                              ));
    }
  }
  void sendUpdateUserPassword(){
    if(formKey2.currentState.validate()){

      if(password2Controller.text.trim() == passwordConfirmController.text.trim()){
        mainModel.updateUserPassword(user_id, password2Controller.text.trim());
        setState(() {
          _isLoading = false;
          _errorNotify = null;
          password2Controller.text = '';
          passwordConfirmController.text = '';
          _isEditPassword = 0;
        });
          
          Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Ваш пароль успешно изменен!"),
                              ));
      }else{
        setState(() {
          _errorNotify = 'Пароли не совпадают!';
        });
      }
      
    }
  }




  void deleteAccount(){
    UserInfoSP.removeUserAllInfo();
    mainModel.deleteUserAccount(user_id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 18.0),
            child: Column(children: <Widget>[
              Material(
                color: Theme.of(context).cardColor,
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      
                        Image(
                          image: AssetImage('assets/profile/user.png'),
                          width: 65,
                          height: 65,
                        ),
                      
                      SizedBox(width: 20.0),
                      user_name == null
                          ? CircularProgressIndicator()
                          : Text(
                              user_name,
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.w600),
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              Material(
                  color: Theme.of(context).cardColor,
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Темный режим',
                          style: listTextStyle,
                        ),
                        Container(
                          width: 100.0,
                          height: 35.0,
                          child: ToggleButtons(
                              onPressed: (int index) {
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = i == index;
                                    if (isSelected[0] == true) {
                                      ThemeModeSP.addBoolThemeMode(true);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  FunToDo()));
                                    } else if (isSelected[1] == true) {
                                      ThemeModeSP.addBoolThemeMode(false);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  FunToDo()));
                                    }
                                  }
                                });
                              },
                              borderColor: Colors.blueAccent,
                              fillColor: Colors.blueAccent,
                              borderWidth: 1,
                              selectedBorderColor: Colors.blueAccent,
                              selectedColor: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              children: [
                                Icon(
                                  Icons.wb_sunny_outlined,
                                  size: 18.0,
                                ),
                                Icon(
                                  Icons.wb_sunny,
                                  size: 18.0,
                                ),
                              ],
                              isSelected: isSelected == null
                                  ? [false, false]
                                  : isSelected),
                        )
                      ],
                    ),
                  )),
              SizedBox(height: 15.0),
              Material(
                color: Theme.of(context).cardColor,
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: !_isEdit
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Редактировать профиль',
                                  style: listTextStyle),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isEdit = true;
                                      nameController.text = user_name;
                                      emailController.text = user_email;
                                    });
                                  },
                                  child: Icon(
                                    Icons.create_outlined,
                                    size: 30.0,
                                  )),
                            ],
                          )
                        : Form(
                            key: formKey,
                            child: Column(children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Редактировать профиль',
                                      style: listTextStyle),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isEdit = false;
                                        });
                                      },
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        size: 30.0,
                                      )),
                                ],
                              ),
                              SizedBox(height: 15.0),
                              _buildNameTextField(),
                              SizedBox(height: 15.0),
                              _buildEmailTextField(),
                              SizedBox(height: 15.0),
                              GestureDetector(
                                onTap: (){
                                  sendUpdateUserInfo();
                                },
                                                              child: Container(
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(30.0)),
                                  child: Center(
                                      child: Text('Применить',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                ),
                              )
                            ]),
                          )),
              ),
              SizedBox(height: 15.0),




              Material(
                color: Theme.of(context).cardColor,
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: _isEditPassword == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Изменить пароль',
                                  style: listTextStyle),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isEditPassword = 1;
                                    });
                                  },
                                  child: Icon(
                                    Icons.create_outlined,
                                    size: 30.0,
                                  )),
                            ],
                          )
                        : _isEditPassword == 1 ? Form(
                            key: formKey2,
                            child: Column(children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Изменить пароль',
                                      style: listTextStyle),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isEditPassword = 0;
                                        });
                                      },
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        size: 30.0,
                                      )),
                                ],
                              ),

                              SizedBox(height: 15.0),
                              _buildPasswordTextField(),
                              SizedBox(height: 15.0),
                              
                              GestureDetector(
                                onTap: (){
                                  sendCheckUserPassword();
                                },
                                                              child: Container(
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(30.0)),
                                  child: Center(
                                      child: !_isLoading ? Text('Применить',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          )) : CircularProgressIndicator()),
                                ),
                              ),
                              _errorNotify != null ? Center(child: Text(_errorNotify, style: TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),),) : Container(),

                            ]),
                          ) : Form(
                            key: formKey2,
                                                      child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Изменить пароль',
                                        style: listTextStyle),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            sendUpdateUserPassword();
                                            _isEditPassword = 0;
                                          });
                                        },
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          size: 30.0,
                                        )),
                                  ],
                                ),

                                SizedBox(height: 15.0),
                                _buildPassword2TextField(),
                                SizedBox(height: 15.0),
                                _buildPasswordConfirmTextField(),
                                SizedBox(height: 15.0),
                                
                                GestureDetector(
                                  onTap: (){
                                    sendUpdateUserPassword();
                                  },
                                                                child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(30.0)),
                                    child: Center(
                                        child: !_isLoading ? Text('Применить',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          )) : CircularProgressIndicator()),
                                  ),
                                ),
                                _errorNotify != null ? Center(child: Text(_errorNotify, style: TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),),) : Container(),

                              ],
                            ),
                          )
                          
                          
                          ),
              ),




              SizedBox(height: 15.0),
              Material(
                color: Theme.of(context).cardColor,
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Удалить аккаунт', style: listTextStyle),
                            !_isDelete ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isDelete = true;
                                  });
                                },
                                child: Icon(
                                  Icons.delete_outline,
                                  size: 30.0,
                                  color: Colors.redAccent,
                                )) : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isDelete = false;
                                  });
                                },
                                child: Icon(
                                  Icons.cancel_outlined,
                                  size: 30.0,
                                 
                                )),
                          ],
                        ),
                        _isDelete ? 
                        Column(
                          children: [
                            SizedBox(height: 10.0,),
                            Text('Вы точно хотите удалить аккаунт?', style: TextStyle(color: Colors.red, fontSize: 18.0, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10.0,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    deleteAccount();
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                              builder: (BuildContext context) => FunToDo()));
                                  },
                                                                  child: Container(
                                    decoration: BoxDecoration(
                                     color: Colors.redAccent,
                                     borderRadius: BorderRadius.only(
                                       topLeft: Radius.circular(30.0), 
                                       bottomLeft: Radius.circular(30.0), 
                                      ),
                                      ),
                                    
                                  height: 40.0,
                                  width: 120.0,
                              alignment: Alignment.center,
                                  child: Text('Удалить', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                              ),
                                ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    _isDelete = false;
                                  });
                                },
                                                              child: Container(
                                  decoration: BoxDecoration(
                                   color: Colors.green,
                                   borderRadius: BorderRadius.only(
                                       topRight: Radius.circular(30.0), 
                                       bottomRight: Radius.circular(30.0), 
                                      ),
                                  ),
                                  height: 40.0,
                                  width: 120.0,
                                alignment: Alignment.center,
                                  child: Text('Отмена', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                ),
                              )
                              ],
                            ),
                          ],
                        ) : Container()
                      ],
                    )),
              ),
              SizedBox(height: 80.0),
              Center(
                  child: GestureDetector(
                      onTap: () {
                        UserInfoSP.removeUserAllInfo();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => FunToDo()));
                      },
                      child: Text('Выйти',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500))))
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
        controller: nameController,
        validator: (val) {
          return val.length > 1 ? null : 'Введите ваше имя!';
        },
        decoration: InputDecoration(
          hintText: 'Ваше имя',
          hintStyle: TextStyle(color: Colors.grey[700], fontSize: 18.0),
        ));
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
        ));
  }

  









Widget _buildPasswordTextField() {
    return TextFormField(
            controller: passwordController,
            validator: (val) {
          return val.length > 5 ? null : 'Пароль не должен быть меньше 5 символов';
        },
        decoration: InputDecoration(
            hintText: 'Ваш текущий пароль',
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
  Widget _buildPassword2TextField() {
    return TextFormField(
            controller: password2Controller,
            validator: (val) {
          return val.length > 5 ? null : 'Пароль не должен быть меньше 5 символов';
        },
        decoration: InputDecoration(
            hintText: 'Ваш новый пароль',
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
  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
            controller: passwordConfirmController,
            validator: (val) {
          return val.length > 5 ? null : 'Пароль не должен быть меньше 5 символов';
        },
        decoration: InputDecoration(
            hintText: 'Повторите новый пароль',
            hintStyle: TextStyle(color: Colors.grey[700], fontSize: 18.0),
            suffixIcon:
                IconButton(
                  onPressed: () {
                    setState(() {
                      _toggleVisibility2 = !_toggleVisibility2;
                    });
                  }, 
                  icon: _toggleVisibility2 ? Icon(Icons.visibility_off) : Icon(Icons.visibility) 
                  )
              ),
        obscureText: _toggleVisibility2,
      );
  }








}
