
part of '../fort.dart';

///A Keep is a type of Tower that comunicates with the lazy boxes within the fort to maintain state syncronization across multiple redux states
abstract class Keep<T extends FortState<S>, S extends KeepObject> extends Store<T>{

  ///Key to the object with type S
  final String objectID;

  ///The key to the box with the object of type S
  final String fortKey;

  ///Construcor
  Keep(Reducer<T> reducer, {
    required this.objectID,
    required this.fortKey,
    required T initialState,
    List<Middleware<T>> middleware = const [],
    bool syncStream = false,
    bool distinct = false,
  }) : super(
    Tower._TowerReducer<T, S>(reducer),
    initialState: initialState,
    middleware: [...middleware, thunkMiddleware],
    syncStream: syncStream,
    distinct: distinct
  ){

    ///Registers the adapter to fort
    Fort().registerAdapter(getStateAdapter);

    //Sends the hydrate action
    dispatch(startHydrateAction());
  }

  ///Returns a hydrated state
  ThunkAction<T> startHydrateAction([bool refresh = false]) {
    return (Store<T> store) async {
      
      Box<S> fortBox = await Fort().storeBox<S>(fortKey);

      S? object = fortBox.get(objectID);

      if(object == null){
        //Retreive object and store it
        object = await retreiveObject(objectID);
        await fortBox.put(objectID, object);
      }

      T? newState = await getStoredHydrate(object.hydratedStateKey);
      if(newState == null || refresh){
        //No hydrated state stored or refresh called, hydrate
        newState = await hydrateState(object);
        dispatch(storeAction(newState));

        //Store the object with the hydrated state key
        object.hydratedStateKey = newState.key;
        await fortBox.put(objectID, object);
      }

      dispatch(SetState(newState));
      _bind(newState.key);

    };
  }

  ///Run when a store state is received from the listener
  ThunkAction<T> receiveAction(T state){
    return (Store<T> store) async {
      //Stores the box
      await onReceive(state);

      dispatch(SetState(state));
    };
  }

  ///Stores the state in the Fort, opposite side of this is [receiveAction]
  ThunkAction<T> storeAction(T state){
    return (Store<T> store) async {
      //Stores the box
      await storeState(state);
    };
  }

  ///Stores the current state into hive and returns the id
  Future<dynamic> storeState(T storeState) async {
    if(storeState.box == null){
      await Fort().lazyBox.add(storeState);
    }
    else{
      await storeState.save();
    }
    return state.key;
  }

  ///Retreives the hydrated state from a hydratedStateKey. 
  ///Retruns null if there is no state stored
  Future<T?> getStoredHydrate(String? hydratedStateKey) async {
    if(hydratedStateKey == null) return null;
    return await Fort().lazyBox.get(hydratedStateKey);
  }

  ///Binds the receive action to the box
  void _bind(String? hydratedStateKey) {
    Fort().lazyBox.listenable(keys: [hydratedStateKey]).addListener(() async {
      //Send a receive action
      dispatch(receiveAction(await Fort().lazyBox.getAt(0)));
    });
  }

  TypeAdapter<T> get getStateAdapter;

  Future<S> retreiveObject(String id);

  Future<T> hydrateState(S object);

  ///Runs when the receive action is run
  Future<void> onReceive(T state);

}