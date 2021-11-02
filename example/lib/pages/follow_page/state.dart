
part of 'page.dart';

/*
 
   ____  _        _       
  / ___|| |_ __ _| |_ ___ 
  \___ \| __/ _` | __/ _ \
   ___) | || (_| | ||  __/
  |____/ \__\__,_|\__\___|
                          
 
*/
enum LoadState {
  NONE,
  LOADING,
  LOADED,
  ERROR
}

class FollowPageState{

  final List<String> userIDs;
  final LoadState loadState;
  final String? errorMessage;

  FollowPageState({
    required this.userIDs,
    this.loadState = LoadState.NONE,
    this.errorMessage
  });

  factory FollowPageState.innitial() => FollowPageState(userIDs: [],);

}

/*
 
   _____                 _       
  | ____|_   _____ _ __ | |_ ___ 
  |  _| \ \ / / _ \ '_ \| __/ __|
  | |___ \ V /  __/ | | | |_\__ \
  |_____| \_/ \___|_| |_|\__|___/
                                 
 
*/

abstract class FollowPageEvent{}

class _LoadUsers extends FollowPageEvent{}
  
class _UsersLoaded extends FollowPageEvent{

  final List<String> userIDs;

  _UsersLoaded(this.userIDs);

}
  
class _FailedUsersLoaded extends FollowPageEvent{

  final String? error;

  _FailedUsersLoaded([this.error]);

}
  

/*
 
   _____ _                 _      __  __ _     _     _ _                             
  |_   _| |__  _   _ _ __ | | __ |  \/  (_) __| | __| | | _____      ____ _ _ __ ___ 
    | | | '_ \| | | | '_ \| |/ / | |\/| | |/ _` |/ _` | |/ _ \ \ /\ / / _` | '__/ _ \
    | | | | | | |_| | | | |   <  | |  | | | (_| | (_| | |  __/\ V  V / (_| | | |  __/
    |_| |_| |_|\__,_|_| |_|_|\_\ |_|  |_|_|\__,_|\__,_|_|\___| \_/\_/ \__,_|_|  \___|
                                                                                     
 
*/

LoadUsersEvent(Store<FollowPageState> store) async {
  store.dispatch(_LoadUsers());

  Api.getUsers().then((users) async {
    store.dispatch(_UsersLoaded(users.map<String>((u) => u.id!).toList()));

    Box<User> userStore = await ConcreteFort().storeBox<User>(FortKey.USER_KEY);
    for (var user in users) {
      userStore.put(user.id, user);
    }
  }).catchError((err){
    store.dispatch(_FailedUsersLoaded(err));
  });

}

// ThunkAction<FollowPageState> FollowUserAction(String userID){
//   return (Store<FollowPageState> store) async {
//     FollowPageState state = store.state;
//     if(state.loadState == LoadState.LOADED){

//       User? followUser = await Api.addFollower(userID);
      
//       if(followUser != null){

//         //Local State
//         Box<User> userStore = await ConcreteFort().storeBox(FortKey.USER_KEY);
//         userStore.put(userID, followUser);

//       }
//     }
//   };
// }

// ThunkAction<FollowPageState> UnfollowUserAction(String userID){
//   return (Store<FollowPageState> store) async {
//     FollowPageState state = store.state;
//     if(state.loadState == LoadState.LOADED){

//       User? followUser = await Api.removeFollower(userID);

//       if(followUser != null){

//         //Local State
//         Box<User> userStore = await ConcreteFort().storeBox(FortKey.USER_KEY);
//         userStore.put(userID, followUser);

//       }
//     }
//   };
// }

/*
 
   ____          _                     
  |  _ \ ___  __| |_   _  ___ ___ _ __ 
  | |_) / _ \/ _` | | | |/ __/ _ \ '__|
  |  _ <  __/ (_| | |_| | (_|  __/ |   
  |_| \_\___|\__,_|\__,_|\___\___|_|   
                                       

*/

FollowPageState followPageReducer(FollowPageState state, dynamic event){

  if(event is FollowPageEvent){
    //Logic
    if(state.loadState == LoadState.LOADING){
      if(event is _UsersLoaded){
        return FollowPageState(
          userIDs: event.userIDs,
          loadState: LoadState.LOADED
        );
      }
      else if(event is _FailedUsersLoaded){
        return FollowPageState(
          userIDs: [],
          loadState: LoadState.ERROR,
          errorMessage: event.error
        );
      }
    }
    else if(event is _LoadUsers){
      return FollowPageState(
        userIDs: [],
        loadState: LoadState.LOADING
      );
    }
  }

  return state;
}

/*
 
   _   _      _                     
  | | | | ___| |_ __   ___ _ __ ___ 
  | |_| |/ _ \ | '_ \ / _ \ '__/ __|
  |  _  |  __/ | |_) |  __/ |  \__ \
  |_| |_|\___|_| .__/ \___|_|  |___/
               |_|                  
 
*/