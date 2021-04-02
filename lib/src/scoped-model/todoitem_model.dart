import 'dart:convert';

import 'package:fun_to_do/helpers/urls_helper.dart';
import 'package:fun_to_do/src/models/todoitem_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class ToDoItemModel extends Model{


  List<ToDoItem> _toDoItems = [];
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<ToDoItem> get toDoItems {
    return List.from(_toDoItems);
  }



  void addToDoItem(String title, String priority, String user_id) async{
    _isLoading = true;
    notifyListeners();
    print(title +' : ' + priority);
    var response = await http.post(UrlsHelper.addItemsUrl, body: {'title': title, 'priority': priority, 'user_id':user_id});
    
    if(response.statusCode == 200){
      dynamic jsonRes = json.decode(response.body);
      print('add IT IS ${jsonRes}');
      
      
    }else{
      print('add ERORRR');
    }
  }






  void fetchToDoItems(String user_id) async{
    _isLoading = true;
    notifyListeners();

    
    http
        .post(
            UrlsHelper.getItemsUrl, body: {'user_id':user_id})
        .then((http.Response response) {
      // print('Fetching data + ${response.body}');
      final List fetchedData = json.decode(response.body);
      final List<ToDoItem> fetchedtoDoItems = [];
      print(fetchedData);
      
      fetchedData.forEach((data) {
        ToDoItem toDoItem = ToDoItem(
          id: int.parse(data['id']),
          title: data["title"],
          done: int.parse(data['done']),
          priority: int.parse(data['priority']),
        );
        // print(data);
        fetchedtoDoItems.add(toDoItem);
        
      });

      _toDoItems = fetchedtoDoItems;
      // print(_toDoItems);
      _isLoading = false;
      notifyListeners();
    });
    

  }



  void updateDataDone(String id, String done) async{
    _isLoading = true;
    notifyListeners();
    print('id: ${id}');
    print('done: ${done}');
    var response = await http.post(UrlsHelper.updateDoneItemsUrl, body: {'id': id, 'done': done});
    
    if(response.statusCode == 200){
      dynamic jsonRes = json.decode(response.body);
      print('update IT IS ${jsonRes}');
    
      
    }else{
      print('update ERORRR');
    }
  
  }

  void updateDataAll(String id, String title, String priority) async{

    print('id:' + id);
    print('title:' + title);
    print('priority:' + priority);
    var response = await http.post(UrlsHelper.updateAllItemsUrl, body: {'id':id, 'title':title, 'priority':priority});
    
    if(response.statusCode == 200){
      dynamic jsonRes = json.decode(response.body);
      print('update IT IS ${jsonRes}');
    
      
    }else{
      print('update ERORRR');
    }
   
  }



  void deleteData(String id) async{
    _isLoading = true;
    notifyListeners();
    print('id: ${id}');
    var response = await http.post(UrlsHelper.deleteItemsUrl, body: {'id': id});
    
    if(response.statusCode == 200){
      dynamic jsonRes = json.decode(response.body);
      print('delete IT IS ${jsonRes}');
      
    }else{
      print('delete ERORRR');
    }
        

     

   
  }


}
