import 'package:flutter/material.dart';
import 'package:fun_to_do/src/pages/add_page.dart';
import 'package:fun_to_do/src/pages/home_page.dart';
import 'package:fun_to_do/src/pages/profile_page.dart';
import 'package:fun_to_do/src/scoped-model/main_model.dart';
import 'package:fun_to_do/src/service/user_info_sp.dart';

import '../app.dart';

class MainScreen extends StatefulWidget {

  final MainModel model;
  final String token;
  final String user_id;
  

  MainScreen({this.model, this.token, this.user_id});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  getUser_idSP()async{
    String user_id = await UserInfoSP.getUserUser_id();
    // print('getUser_idSP App : ${user_id}');
    return user_id;
  }
  String user_id;
  
  int currentTabIndex  = 1;

  List<Widget> pages;

  Widget currentPage;

  HomePage homePage;

  ProfilePage profilePage;

  AddPage addPage;

  @override
  void initState() {
    
      
    widget.model.fetchToDoItems(widget.user_id);
      
    

    homePage = HomePage();
    profilePage = ProfilePage();
    addPage = AddPage();
    pages = [addPage, homePage, profilePage];

    currentPage = homePage;
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        children: [
          Image(image: AssetImage('assets/icons/fun_logo_v2.png'), width: 55, height: 55,),
          SizedBox(width: 10.0),
          Text(currentPage == homePage ? 'Fun ToDo' : currentPage == profilePage ? 'Мой профиль' : 'Добавление', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.0)),
        ],
      ),),
      body: currentPage,
      
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index){
          if(index == 1) {
            // setState(() {
            //   widget.model.fetchToDoItems(widget.user_id);
            // });
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => FunToDo()));

              
          }
          setState(() {
            
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        elevation: 15.0,
        currentIndex: currentTabIndex,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Добавить'),
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            title: Text('Дела'),
            
          ), 
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('Профиль'),
            
          )
        ],
      ),
    );
  }
}