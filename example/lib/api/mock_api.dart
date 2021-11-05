import 'package:fort/fort.dart';
import 'package:fort_example/models/hydrated_keep_state.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/state/fort_keys.dart';
import 'package:fort_example/state/user_keep/state.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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

        //Hydrated data already in the model? make sure its a dry keep 
        //PRE HYDRATE
        final keep = UserKeep.dry(user.id!, user);
        bool preStored = await keep.awaitHydrate;
        if(keep.state.state == HydratedKeepStates.ACTIVE){
          UserKeepState newState = keep.state.copyWith(UserKeepState(
            follows: user.follows ?? 0,
          )) as UserKeepState;
          keep.dispatchStore(newState);
        }
        else{
          UserKeepState newState = UserKeepState(
            state: HydratedKeepStates.ACTIVE,
            hydratedTime: _formatNowTime(),
            follows: user.follows ?? 0,
          );
          keep.dispatchStore(newState);
        }
      }
    }

    await Future.delayed(const Duration(seconds: 3));

    await userDBBox.close();

    return users;
  }

  static Future<User> getUserByID(String id) async {

    LazyBox<User> userDBBox = await Hive.openLazyBox<User>(user_db);

    if(userDBBox.isEmpty){
      await _init();
    }

    User? user = await userDBBox.get(id);

    return user!;
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

    //Local State
    Box<User> userStore = await Fort().storeBox(FortKey.USER_KEY);
    userStore.put(userID, apiUser);

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

    //Local State
    Box<User> userStore = await Fort().storeBox(FortKey.USER_KEY);
    userStore.put(userID, apiUser);

    //Return
    return apiUser;
  }

  // static Future<void> reloadState() async {
  //   await Fort().clearBox(FortKey.USER_KEY);
  // }

  ///DO NOT USE KEEPS INSIDE OF HYDRATERS
  static Future<int> hydrateFollowers(String objectID) async {
    User? user = await Api.getUserByID(objectID);
    return user.follows ?? 0;
  }

  static Future<String> hydrate() async {
    await Future.delayed(const Duration(seconds: 1));
    return Api._formatNowTime();
  }

  static String _formatNowTime(){
    DateTime time = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd  hh:mm');
    final String formatted = formatter.format(time);
    return formatted;
  }

}