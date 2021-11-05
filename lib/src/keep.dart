
part of '../fort.dart';

///A Keep is a type of Tower that comunicates with the lazy boxes within the fort to maintain state syncronization across multiple redux states
abstract class Keep<T extends FortState<S>, S> extends Store<T>{

  ///Key Base
  final String keyBase;

  ///Key to the object with type S
  final String objectID;

  ///The key to the box with the object of type S
  final String fortKey;

  ///Competer for the hydrate
  final Completer<bool> hydrator = Completer<bool>();

  ///Construcor
  Keep(Reducer<T> reducer, {
    required this.objectID,
    required this.fortKey,
    required T initialState,
    required this.keyBase,
    List<Middleware<T>> middleware = const [],
    bool syncStream = false,
    bool distinct = false,
    bool dry = false
  }) : super(
    Tower._TowerReducer<T, S>(reducer),
    initialState: initialState,
    middleware: [...middleware, thunkMiddleware],
    syncStream: syncStream,
    distinct: distinct
  ){
    
    ///Registers the adapter to fort
    Fort().registerAdapter(getStateAdapter);

    _bind(keepKey);

    //Sends the hydrate action
    dispatch(startHydrateAction(dry: dry));
  }

  ///Returns a hydrated state
  ThunkAction<T> startHydrateAction({bool refresh = false, bool dry = false}) {
    return (Store<T> store) async {
      
      Box<S> fortBox = await Fort().storeBox<S>(fortKey);

      S? object = fortBox.get(objectID);

      if(object == null){
        //Retreive object and store it
        object = await retreiveObject(objectID);
        await fortBox.put(objectID, object!);
      }

      T? newState = await getStoredHydrate(keepKey);
      if((newState == null && !dry) || refresh){
        //No hydrated state stored or refresh called, hydrate
        newState = await hydrateState(object);
        await storeState(newState);
        hydrator.complete(false);
      }
      else{
        hydrator.complete(true);
      }


      
      if(newState != null){
        dispatch(SetState(newState));
      }

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

  void dispatchStore(T storeState) => dispatch(storeAction(storeState));

  ///Stores the current state into hive and returns the id
  Future<dynamic> storeState(T storeState) async {
    if(storeState.box == null){
      await Fort().lazyBox.put(keepKey, storeState);
    }
    else{
      await storeState.save();
    }
    return keepKey;
  }

  ///Retreives the hydrated state from a hydratedStateKey. 
  ///Retruns null if there is no state stored
  Future<T?> getStoredHydrate(dynamic hydratedStateKey) async {
    if(hydratedStateKey == null) return null;
    return await Fort().lazyBox.get(hydratedStateKey);
  }

  ///Binds the receive action to the box
  void _bind(dynamic hydratedStateKey) {
    Fort().lazyBox.listenable(keys: [hydratedStateKey]).addListener(() async {
      //Send a receive action
      dispatch(receiveAction(await Fort().lazyBox.get(keepKey)));
    });
  }

  String get keepKey => keyBase + '-' + objectID;

  Future<bool> get awaitHydrate => hydrator.future;

  TypeAdapter<T> get getStateAdapter;

  Future<S> retreiveObject(String id);

  Future<T> hydrateState(S object);

  ///Runs when the receive action is run
  Future<void> onReceive(T state);

}