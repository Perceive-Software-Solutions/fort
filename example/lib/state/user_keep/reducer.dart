
part of 'state.dart';

/*
 
   ____          _                     
  |  _ \ ___  __| |_   _  ___ ___ _ __ 
  | |_) / _ \/ _` | | | |/ __/ _ \ '__|
  |  _ <  __/ (_| | |_| | (_|  __/ |   
  |_| \_\___|\__,_|\__,_|\___\___|_|   
                                       
 
*/

UserKeepState userKeepReducer(UserKeepState state, dynamic event){


  return state;
}

/*
 
   _____                 _       
  | ____|_   _____ _ __ | |_ ___ 
  |  _| \ \ / / _ \ '_ \| __/ __|
  | |___ \ V /  __/ | | | |_\__ \
  |_____| \_/ \___|_| |_|\__|___/
                                 
 
*/

abstract class UserEvent extends FortEvent{}

/*
 
      _        _   _                 
     / \   ___| |_(_) ___  _ __  ___ 
    / _ \ / __| __| |/ _ \| '_ \/ __|
   / ___ \ (__| |_| | (_) | | | \__ \
  /_/   \_\___|\__|_|\___/|_| |_|___/
                                     
 
*/

void addFollowerAction(Store<UserKeepState> store) async {
  User? user = await Api.addFollower((store as UserKeep).objectID);

  UserKeepState newState = store.state.copyWith(UserKeepState(
    state: HydratedKeepStates.ACTIVE,
    follows: user!.follows
  )) as UserKeepState;

  store.dispatch(store.storeAction(newState));
}

void removeFollowerAction(Store<UserKeepState> store) async {
  User? user = await Api.removeFollower((store as UserKeep).objectID);

  store.dispatch(store.storeAction(UserKeepState(
    state: HydratedKeepStates.ACTIVE,
    hydratedTime: await Api.hydrate(),
    follows: user!.follows
  )));
}