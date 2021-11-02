// ignore_for_file: non_constant_identifier_names

part of '../fort.dart';


typedef SerializationFunction<T extends FortState> = T? Function(dynamic json);

class Tower<T extends FortState> extends Store<T>{

  ///If defined the redux state will persist
  final Persistor<T>? persistor;

  ///Default Constructor
  factory Tower(
    Reducer<T> reducer, {
    required T initialState,
    List<Middleware<T>> middleware = const [],
    bool syncStream = false,
    bool distinct = false,
    SerializationFunction<T>? serializer ///When defined creates a persistor
  }){

    Persistor<T>? persistor;
    if(serializer != null){
      persistor = Persistor<T>(
        storage: FlutterStorage(location: FlutterSaveLocation.sharedPreferences),
        serializer: JsonSerializer(serializer)
      );
    }

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
    this.persistor
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
      }

    }

  }


}