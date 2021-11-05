part of 'state.dart';

class UserKeep extends Keep<UserKeepState, User>{

  static const String KEY_BASE = 'USER-KEEP-KEY-BASE';

  ///Redyundant keyGet function
  static String getKeepKey(String userID) => KEY_BASE + '-' + userID;

  ///Called when a sync event is received by a syncronized UserKeep
  Function(UserKeepState state)? onSync;
  
  UserKeep(
    String objectID, {
    List<Middleware<UserKeepState>> middleware = const [],
    bool syncStream = false,
    bool distinct = false,
    bool dry = false,
    this.onSync
  }) : super(
    userKeepReducer,
    keyBase: UserKeep.KEY_BASE,
    objectID: objectID,
    fortKey: FortKey.USER_KEY,
    initialState: UserKeepState.initial(),
    middleware: middleware,
    syncStream: syncStream,
    distinct: distinct,
    dry: dry
  );

  factory UserKeep.dry(String objectID, User user){
    (Fort().box(FortKey.USER_KEY)).put(objectID, user);
    return UserKeep(objectID, dry: true);
  } 

  @override
  TypeAdapter<UserKeepState> get getStateAdapter => UserKeepStateAdapter();

  @override
  Future<UserKeepState> hydrateState(User object) async {
    //Call functions to hydrate the state
    String hydrate = await Api.hydrate();

    int follows = await Api.hydrateFollowers(objectID);

    return UserKeepState(
      state: HydratedKeepStates.ACTIVE,
      hydratedTime: hydrate,
      follows: follows
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

