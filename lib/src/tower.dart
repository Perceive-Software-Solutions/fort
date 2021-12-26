// ignore_for_file: non_constant_identifier_names

part of '../fort.dart';

typedef SerializationFunction<T extends FortState> = T? Function(dynamic json);

typedef PersistorCallBackFunction<T, S extends FortState<T>> = Function(Tower<T, S> tower, S loadedState);

class Tower<T, S extends FortState<T>> extends Store<S>{

  ///If defined the redux state will persist
  final Persistor<S>? persistor;

  /// Only needed if [persistor] is defined. 
  /// Runs when if the persistor loads in a state
  final PersistorCallBackFunction<T, S>? persistorCallBack;

  ///Default Constructor
  factory Tower(
    Reducer<S> reducer, {
    required S initialState,
    List<Middleware<S>> middleware = const [],
    bool syncStream = false,
    bool distinct = false,
    SerializationFunction<S>? serializer, ///When defined creates a persistor
    PersistorCallBackFunction<T, S>? persistorCallBack 
  }){

    Persistor<S>? persistor;
    if(serializer != null){
      persistor = Persistor<S>(
        storage: FlutterStorage(location: FlutterSaveLocation.sharedPreferences),
        serializer: JsonSerializer(serializer)
      );

      //Add persistor middleware
      middleware = [persistor.createMiddleware(), ...middleware];
    }

    //Adds thunk middleware
    middleware = [thunkMiddleware, ...middleware];

    //Default event reducer
    return Tower._(
      Tower._TowerReducer<T, S>(reducer),
      initialState: initialState,
      middleware: middleware,
      syncStream: syncStream,
      distinct: distinct,
      persistor: persistor
    );
  }

  ///Private constructor
  Tower._(
    Reducer<S> reducer, {
    required S initialState,
    List<Middleware<S>> middleware = const [],
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

  static Reducer<S> _TowerReducer<T, S extends FortState<T>>(Reducer<S> reducer){
    return (S state, dynamic event){

      if(event is SetState){
        return event.state as S;
      }
      else if(event is CopyStateWith<T>){
        return state.copyWith(event.state) as S;
      }

      return reducer(state, event);
    };
  }

  Future<void> initializeFromPersistor() async {

    if(persistor != null){
      try{
        S? loadedState = await persistor!.load();

        if(loadedState != null){
          //Set state wil the new state
          dispatch(SetState(loadedState));

          //Runs any call backs on the persistor
          if(persistorCallBack != null){
            persistorCallBack!(this, loadedState);
          }
        }
      }catch(e){
        return;
      }

    }

  }
}