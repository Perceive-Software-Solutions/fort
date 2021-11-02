
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

part 'local_state/fort_event.dart';
part 'local_state/fort_state.dart';
part 'local_state/tower.dart';

class Fort {

  static late final Fort _fort = Fort._internal();
  
  Fort._internal();

  factory Fort() => _fort;

/*
 
   ____  _        _       
  / ___|| |_ __ _| |_ ___ 
  \___ \| __/ _` | __/ _ \
   ___) | || (_| | ||  __/
  |____/ \__\__,_|\__\___|
                          
 
*/

  //If the value is true, then the box is open
  Map<String, Type> openBoxes = {};

/*
 
   _____                 _       
  | ____|_   _____ _ __ | |_ ___ 
  |  _| \ \ / / _ \ '_ \| __/ __|
  | |___ \ V /  __/ | | | |_\__ \
  |_____| \_/ \___|_| |_|\__|___/
                                 
 
*/

  ///Registers a type adapter to a key and opens the box for the objects. 
  ///Boxes must initlaly be registered before used
  Future<Box<T>> register<T>(String key, TypeAdapter<T> adapter) async {
    
    //Registers the storage system in flutter
    if(openBoxes.isEmpty){
      await Hive.initFlutter();
    }

    if(openBoxes[key] != T){
      //register the adapter if it is not registered
      Hive.registerAdapter<T>(adapter);
    }
    
    //Returns the open box
    return await storeBox<T>(key);

  }

  ///Opens a box and returns an open box
  Future<Box<T>> storeBox<T>(String boxKey) async {
    
    if(openBoxes[boxKey] == T){
      //Box already open
      return Hive.box<T>(boxKey);
    }
    else{
      //Open the box
      Box<T> box = await Hive.openBox<T>(boxKey);
      openBoxes[boxKey] = T;
      return box;
    }
  }

  ///Returns an open store or null
  ValueListenable<Box<T>> getStoreListener<T>(String boxKey, [List<dynamic>? listenerKeys]) {
    if(openBoxes[boxKey] == T){
      //Box already open
      return Hive.box<T>(boxKey).listenable(keys: listenerKeys);
    }
    throw 'Box Not Open';
  }

}