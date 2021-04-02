import 'package:flutter/material.dart';
import 'package:fun_to_do/src/widgets/todoitem_card.dart';

class ViewAllToDo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
            // future: myToDoItemModel.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              snapshot.hasData ? print(snapshot.data) : null;
              return snapshot.hasData
                  ? ListItem(
                      list: snapshot.data.toList(),
                    )
                  : Center(child: CircularProgressIndicator());
            },
          )
    ;
  }
}

class ListItem extends StatelessWidget {
  List list;
  ListItem({this.list});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2.0),
            child: ToDoItemCard(
                
                id: int.parse(list[i]['id']),
                title: list[i]['title'],
                done: int.parse(list[i]['done']),
                
              ),
            );
        },
      ),
    );
  }
}