import 'package:fun_to_do/src/scoped-model/todoitem_model.dart';
import 'package:fun_to_do/src/scoped-model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with ToDoItemModel, UserModel{

}