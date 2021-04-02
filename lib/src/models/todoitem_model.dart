class ToDoItem {
  final int id;
  final String title;
  final int done;
  final int priority;

  ToDoItem({this.id, this.title, this.done, this.priority});

  factory ToDoItem.fromJson(Map<String,dynamic> json){
    return ToDoItem(
        id:  json['id'],
        title: json['title'],
        done: json['done'],
        priority: json['priority'],
    );
  }
}