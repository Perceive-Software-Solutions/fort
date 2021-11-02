import 'package:fort_example/models/user.dart';
import 'package:fort_example/state/concrete_fort.dart';
import 'package:fort_example/state/fort_keys.dart';
import 'package:hive/hive.dart';

class Api{

  static const String user_db = 'user-datastore';

  //Creates the user db
  static Future<void> _init() async {

    LazyBox<User> userDBBox = Hive.lazyBox<User>(user_db);

    List<User> users = [
      {"id": "1", "name": "Ibtesam Mahmood"},
      {"id": "2", "name": "Liam Cookie"},
      {"id": "3", "name": "Markooos Kohler"},
      {"id": "4", "name": "Aleksander Essex"},
      {"id": "5", "name": "Jake Pawl"},
      {"id": "6", "name": "Elmo Wizard"},
      {"id": "7", "name": "Sanji Kusakabe"},
      {"id": "8", "name": "Billy The Barber"},
      {"id": "9", "name": "Yoha Ila"},
      {"id": "10", "name": "Zee Mer"},
    ].map<User>((e) => User.fromJson(e)).toList();

    Map<String, User> boxInput = {};
    for (var user in users) {
      boxInput[user.id!] = user;
    }

    await userDBBox.putAll(boxInput);

  }

  //Returns the users
  static Future<List<User>> getUsers([int size = 10]) async {
    
    LazyBox<User> userDBBox = await Hive.openLazyBox<User>(user_db);

    if(userDBBox.isEmpty){
      await _init();
    }

    List<User> users = [];
    for (var i = 1; i <= size; i++) {
      User? user = await userDBBox.get("$i");
      if(user != null){
        users.add(user);
      }
    }

    await userDBBox.close();

    return users;
  }

  //Add a follower to a user
  static Future<User?> addFollower(String userID) async {

    LazyBox<User> userDBBox = await Hive.openLazyBox<User>(user_db);

    if(userDBBox.isEmpty){
      await _init();
    }

    //Api Call
    User? apiUser = await userDBBox.get(userID);
    if(apiUser == null){
      //error check
      return null;
    }
    
    //Update the follow count and store user
    apiUser.follows = (apiUser.follows ?? 0) + 1;
    await userDBBox.put(userID, apiUser);

    await userDBBox.close();

    //Return
    return apiUser;

  }

    //Add a follower to a user
  static Future<User?> removeFollower(String userID) async {

    LazyBox<User> userDBBox = await Hive.openLazyBox<User>(user_db);

    if(userDBBox.isEmpty){
      await _init();
    }

    //Api Call
    User? apiUser = await userDBBox.get(userID);
    if(apiUser == null){
      return null;
    }
    
    if(apiUser.follows == 0){
      return apiUser;
    }
    
     //Update the follow count and store user
    apiUser.follows = (apiUser.follows ?? 1) - 1;
    await userDBBox.put(userID, apiUser);
    
    await userDBBox.close();

    //Return
    return apiUser;
  }

}