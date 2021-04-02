import 'package:flutter/material.dart';
import 'package:fun_to_do/src/pages/edit_page.dart';
import 'package:fun_to_do/src/scoped-model/main_model.dart';

class ToDoItemCard extends StatefulWidget {
  final int id;
  final String title;
  final int done;
  final int priority;

  const ToDoItemCard({this.id, this.title, this.done, this.priority});

  @override
  _ToDoItemCardState createState() => _ToDoItemCardState();
}

class _ToDoItemCardState extends State<ToDoItemCard> {
  bool isClosed = false;

  void deleteToDo() {
    setState(() {
      isClosed = true;
    });
    mainModel.deleteData(widget.id.toString());
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Ваше дело успешно удалено!"),
    ));
  }
  void editToDo() {
    if(widget.id != 1){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EditPage(id: widget.id, title: widget.title, priority: widget.priority,)));
    }    
  }

  MainModel mainModel = MainModel();

  bool checkBox;
  @override
  void initState() {
    super.initState();

    widget.done == 1 ? checkBox = true : checkBox = false;
  }

  @override
  Widget build(BuildContext context) {
    return !isClosed
        ? Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Card(
              color: widget.priority == 0
                  ? Theme.of(context).cardColor
                  : widget.priority == 1
                      ? Colors.yellow
                      : Colors.redAccent,
              elevation: 4.0,
              child: Stack(
                
                              children: [Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                          value: checkBox,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (bool value) {
                            setState(() {
                              checkBox = value;
                            });
                            mainModel.updateDataDone(
                                widget.id.toString(), checkBox.toString());

                            print('done ${checkBox}');
                          }),

                      // SizedBox(width: 10.0),
                      Container(
                          width: 240.0,
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          )),

                      
                    ],
                  ),
                ),
                
                      
                      Positioned(
                        top: 10.0,
                        right: 10.0,
                        
                        child: GestureDetector(
                            onTap: () {
                              deleteToDo();
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 22.0,
                            )),
                      ),
                      
                      Positioned(
                        bottom: 10.0,
                        right: 10.0,
                                              child: GestureDetector(
                          onTap: () {
                            editToDo();
                          },
                          child: Icon(
                            Icons.create_outlined,
                            size: 22.0,
                          ),
                        ),
                      ),
                    
                              ]),
            ))
        : Container(
            width: 0,
            height: 0,
          );
  }
}
