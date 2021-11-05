part of 'state.dart';

class UserKeep extends Keep<UserKeepState, User>{

  ///Called when a sync event is received by a syncronized UserKeep
  Function(UserKeepState state)? onSync;
  
  UserKeep(
    String objectID, {
    List<Middleware<UserKeepState>> middleware = const [],
    bool syncStream = false,
    bool distinct = false,
    this.onSync
  }) : super(
    userKeepReducer,
    objectID: objectID,
    fortKey: FortKey.USER_KEY,
    initialState: UserKeepState.initial(),
    middleware: middleware,
    syncStream: syncStream,
    distinct: distinct
  );

  @override
  TypeAdapter<UserKeepState> get getStateAdapter => UserKeepStateAdapter();

  @override
  Future<UserKeepState> hydrateState(User object) async {
    //Call functions to hydrate the state
    String hydrate = await Api.hydrate();

    return UserKeepState(
      state: HydratedKeepStates.ACTIVE,
      hydrate: hydrate
    );
  }

  @override
  Future<void> onReceive(UserKeepState state) async {
    if(onSync != null){
      onSync!(state);
    }
  }

  @override
  Future<User> retreiveObject(String id) => Api.getUserByID(id);
}

