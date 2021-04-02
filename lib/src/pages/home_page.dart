import 'package:flutter/material.dart';
import 'package:fun_to_do/src/scoped-model/main_model.dart';
import 'package:fun_to_do/src/service/user_info_sp.dart';
import 'package:fun_to_do/src/widgets/todoitem_card.dart';
import 'package:scoped_model/scoped_model.dart';

// Model
import '../models/todoitem_model.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
















class _HomePageState extends State<HomePage> {
    // List<String> sortItems = ['Последние', 'Важные', 'Не выжные', 'Сделанные'];
    // String _dropDownValue;
    final MainModel mainModel = MainModel();

    String user_name;

  getUser_nameSP() async {
    String user_name = await UserInfoSP.getUserUser_name();
    // print('getUsername profilePage : ${user_name}');
    return user_name;
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser_nameSP().then((response) {
      setState(() {
        user_name = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
            child: user_name == null
                          ? CircularProgressIndicator()
                          : Text('Привет ' + user_name + '!',
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            height: 2.0,
            color: Theme.of(context).shadowColor,
          ),
        ),
        SizedBox(height: 20.0),


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: 
              ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model){
                  
                  if(model.toDoItems.isNotEmpty){
                    return Column( children:  model.toDoItems.map(_buildProductItems).toList() ); 

                  }else{
                    return Center(child: CircularProgressIndicator());
                  }
                    
                    
                },
              ),
            
            
        )
      ]),
    );
  }

Widget _buildProductItems(ToDoItem toDoItem){
    
        return Container(
        
        child: ToDoItemCard(
          id: toDoItem.id,
          title: toDoItem.title,
          done: toDoItem.done,
          priority: toDoItem.priority
        ),
      );


    
  }
}
