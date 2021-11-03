// ignore_for_file: non_constant_identifier_names

part of '../fort.dart';

typedef SerializationFunction<T extends FortState> = T? Function(dynamic json);

typedef PersistorCallBackFunction<T extends FortState> = Function(Tower<T> tower, T loadedState);

class Tower<T extends FortState> extends Store<T>{

  ///If defined the redux state will persist
  final Persistor<T>? persistor;

  /// Only needed if [persistor] is defined. 
  /// Runs when if the persistor loads in a state
  final PersistorCallBackFunction<T>? persistorCallBack;

  ///Default Constructor
  factory Tower(
    Reducer<T> reducer, {
    required T initialState,
    List<Middleware<T>> middleware = const [],
    bool syncStream = false,
    bool distinct = false,
    SerializationFunction<T>? serializer, ///When defined creates a persistor
    PersistorCallBackFunction<T>? persistorCallBack 
  }){

    Persistor<T>? persistor;
    if(serializer != null){
      persistor = Persistor<T>(
        storage: FlutterStorage(location: FlutterSaveLocation.sharedPreferences),
        serializer: JsonSerializer(serializer)
      );

      //Add persistor middleware
      middleware = [persistor.createMiddleware(), ...middleware];
    }

    //Adds thunk middleware
    middleware.add(thunkMiddleware);

    //Default event reducer
    return Tower._(
      Tower._TowerReducer<T>(reducer),
      initialState: initialState,
      middleware: middleware,
      syncStream: syncStream,
      distinct: distinct,
      persistor: persistor
    );
  }

  ///Private constructor
  Tower._(
    Reducer<T> reducer, {
    required T initialState,
    List<Middleware<T>> middleware = const [],
    bool syncStream = false,
    bool distinct = false,
    this.persistor,
    this.persistorCallBack
  }) : super(
    reducer,
    initialState: initialState,
    middleware: middleware,
    syncStream: syncStream,
    distinct: distinct
  ) {
    initializeFromPersistor();
  }

  static Reducer<T> _TowerReducer<T extends FortState>(Reducer<T> reducer){
    return (T state, dynamic event){

      if(event is SetState){
        return event.state as T;
      }

      return reducer(state, event);
    };
  }

  Future<void> initializeFromPersistor() async {

    if(persistor != null){
      T? loadedState = await persistor!.load();

      if(loadedState != null){
        //Set state wil the new state
        dispatch(SetState(loadedState));

        //Runs any call backs on the persistor
        if(persistorCallBack != null){
          persistorCallBack!(this, loadedState);
        }
      }

    }

  }
}