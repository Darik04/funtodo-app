class UrlsHelper{
  //main HOST
  static String mainUrl = 'https://darik04.000webhostapp.com/fun-todo.com/';

  //ToDoItems model
  static String getItemsUrl = mainUrl + 'api/todoitems/getToDoItems.php';
  static String updateDoneItemsUrl = mainUrl + 'api/todoitems/updateToDoItemsDone.php';
  static String updateAllItemsUrl = mainUrl + 'api/todoitems/updateToDoItemsAll.php';
  static String deleteItemsUrl = mainUrl + 'api/todoitems/deleteToDoItems.php';
  static String addItemsUrl = mainUrl + 'api/todoitems/addToDoItems.php';

  //User model
  static String updateUserInfoUrl = mainUrl + 'api/users/updateUserInfo.php';
  static String updateUserPasswordUrl = mainUrl + 'api/users/updateUserPassword.php';
  static String deleteUserAccountUrl = mainUrl + 'api/users/deleteUser.php';

  //Sign up page
  static String registerUserUrl = mainUrl + 'api/users/registerUser.php';

  //Sign in page
  static String authtenticatedUserUrl = mainUrl + 'api/users/authUser.php';

  //Profile Page
  static String checkUserPasswordUrl = mainUrl + 'api/users/checkUserPassword.php';

  
}