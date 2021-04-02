import 'package:flutter/material.dart';
import 'package:fun_to_do/src/scoped-model/main_model.dart';

import '../app.dart';

class EditPage extends StatefulWidget {
  final int id;
  final String title;
  final int priority;

  EditPage({this.id, this.title, this.priority});


  @override
  _EditPageState createState() => _EditPageState();
}





class _EditPageState extends State<EditPage> {
  final formKey = GlobalKey<FormState>();

  int priority;

  TextEditingController titleTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    priority = widget.priority;
    titleTextEditingController.text = widget.title;
  }

  void sendForUpdateData(){
    if(formKey.currentState.validate()){
      mainModel.updateDataAll(widget.id.toString(), titleTextEditingController.text.trim(), priority.toString());
      // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Ваше дело успешно изменено!"),));
      
    }
  }
  final MainModel mainModel = MainModel();

  final priorityTextStyle = TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        children: [
          
          Text('Редактирование'),
        ],
      ),),
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
                  sendForUpdateData();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => FunToDo()));
                },
                  child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor,
                  child: Container(
                      height: 50.0,
                      width: 220.0,
                      alignment: Alignment.center,
                      child: Text('Применить',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold))),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
