import 'package:flutter/material.dart';
import 'package:fun_to_do/src/scoped-model/main_model.dart';
import 'package:fun_to_do/src/service/user_info_sp.dart';

class AddPage extends StatefulWidget {

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final formKey = GlobalKey<FormState>();

  int priority;
  String user_id;

  TextEditingController titleTextEditingController = TextEditingController();

  @override
  void initState() {
    
    super.initState();
    priority = 0;
    getUser_idSP().then((response){
      setState(() {
        user_id = response;
      });
    });
  }
  getUser_idSP()async{
    String user_id = await UserInfoSP.getUserUser_id();
    // print('getUser_idSP add : ${user_id}');
    return user_id;
  }

  void sendData(){
    if(formKey.currentState.validate()){
      mainModel.addToDoItem(titleTextEditingController.text.trim(), priority.toString(), user_id);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Ваше дело успешно добавлено!"),));
      setState(() {
        titleTextEditingController.text = '';
        priority = 0;
      });
    }
  }
  MainModel mainModel = MainModel();

  final priorityTextStyle = TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 18.0),
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                              child: TextFormField(
                  controller: titleTextEditingController,
                  validator: (val) {
                    return val.length > 5 ? null : 'Минимум 5 символов!';
                  },
                  maxLength: 200,
                  decoration: InputDecoration(
                      hintText: 'Заголовок...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.topLeft, 
                child: Text('Приоритет', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),)),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: priority == 0 ? 0 : 15.0),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        priority = 0;
                      });
                    },
                                    child: Material(
                      elevation: 4.0,
                        child: Container(
                        color: Colors.white,
                        width: 105.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        child: Text('Низкий', style: priorityTextStyle,)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: priority == 1 ? 0 : 15.0),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        priority = 1;
                      });
                    },
                                    child: Material(
                      elevation: 4.0,
                        child: Container(
                        color: Colors.yellow,
                        width: 105.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        child: Text('Средний', style: priorityTextStyle,)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: priority == 2 ? 0 : 15.0),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        priority = 2;
                      });
                    },
                                    child: Material(
                                      
                      elevation: 4.0,
                        child: Container(
                          
                        color: Colors.redAccent,
                        width: 105.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        child: Text('Высокий', style: priorityTextStyle,)
                      ),
                    ),
                  ),
                )
              ]),

              SizedBox(height: 20.0),

              GestureDetector(
                onTap: (){
                  sendData();
                },
                  child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor,
                  child: Container(
                      height: 50.0,
                      width: 220.0,
                      alignment: Alignment.center,
                      child: Text('Добавить',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black))),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
