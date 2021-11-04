
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

class HomePageState extends FortState<HomePageState>{

  final List<String> userIDs;
  final LoadState loadState;
  final String? errorMessage;

  HomePageState({
    required this.userIDs,
    this.loadState = LoadState.NONE,
    this.errorMessage
  });

  factory HomePageState.innitial() => HomePageState(userIDs: [],);

  static HomePageState fromJson(dynamic json){
    return HomePageState(
      userIDs: (json['userIDs'] as List<dynamic>).cast<String>(),
      loadState: LoadState.values[json['loadState']],
      errorMessage: json['error']
    );
  }

  @override
  dynamic toJson() => {
    'userIDs': userIDs,
    'loadState': LoadState.values.indexOf(loadState),
    'error': errorMessage
  };

  @override
  FortState<HomePageState> copyWith(FortState other) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

}

/*
 
   _____                 _       
  | ____|_   _____ _ __ | |_ ___ 
  |  _| \ \ / / _ \ '_ \| __/ __|
  | |___ \ V /  __/ | | | |_\__ \
  |_____| \_/ \___|_| |_|\__|___/
                                 
 
*/

abstract class HomePageEvent extends FortEvent{}

class SetState extends HomePageEvent{

  final HomePageState state;

  SetState(this.state);

}

class _LoadUsers extends HomePageEvent{}
  
class _UsersLoaded extends HomePageEvent{

  final List<String> userIDs;

  _UsersLoaded(this.userIDs);

}
  
class _FailedUsersLoaded extends HomePageEvent{

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

LoadUsersEvent(Store<HomePageState> store) async {
  store.dispatch(_LoadUsers());

  Api.getUsers().then((users) async {
    store.dispatch(_UsersLoaded(users.map<String>((u) => u.id!).toList()));

    Box<User> userStore = await Fort().storeBox<User>(FortKey.USER_KEY);
    for (var user in users) {
      userStore.put(user.id, user);
    }
  }).catchError((err){
    store.dispatch(_FailedUsersLoaded(err));
  });

}

/*
 
   ____          _                     
  |  _ \ ___  __| |_   _  ___ ___ _ __ 
  | |_) / _ \/ _` | | | |/ __/ _ \ '__|
  |  _ <  __/ (_| | |_| | (_|  __/ |   
  |_| \_\___|\__,_|\__,_|\___\___|_|   
                                       

*/

HomePageState homePageReducer(HomePageState state, dynamic event){

  if(event is HomePageEvent){

    if(event is SetState){
      return event.state;
    }

    //Logic
    else if(state.loadState == LoadState.LOADING){
      if(event is _UsersLoaded){
        return HomePageState(
          userIDs: event.userIDs,
          loadState: LoadState.LOADED
        );
      }
      else if(event is _FailedUsersLoaded){
        return HomePageState(
          userIDs: [],
          loadState: LoadState.ERROR,
          errorMessage: event.error
        );
      }
    }
    else if(event is _LoadUsers){
      return HomePageState(
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