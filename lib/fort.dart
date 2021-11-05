
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';

export 'package:hive/hive.dart';
export 'package:hive_flutter/hive_flutter.dart';
export 'package:redux/redux.dart';
export 'package:flutter_redux/flutter_redux.dart';
export 'package:redux_persist/redux_persist.dart';
export 'package:redux_persist_flutter/redux_persist_flutter.dart';
export 'package:redux_thunk/redux_thunk.dart';

part 'src/fort_event.dart';
part 'src/fort_state.dart';
part 'src/keep.dart';
part 'src/tower.dart';


class Fort {

  static late final Fort _fort = Fort._internal();
  
  Fort._internal();

  factory Fort() => _fort;

  static const String GENERAL_KEY = 'GENERAL-FORT-STORE-KEY';
  static const String LAZY_KEY = 'LAZY-FORT-STORE-KEY';

/*
 
   ____  _        _       
  / ___|| |_ __ _| |_ ___ 
  \___ \| __/ _` | __/ _ \
   ___) | || (_| | ||  __/
  |____/ \__\__,_|\__\___|
                          
 
*/

  //If the value is true, then the box is open
  Map<String, Box<dynamic>> openBoxes = {};

  late LazyBox<dynamic> lazyBox;


/*
 
   _____                 _       
  | ____|_   _____ _ __ | |_ ___ 
  |  _| \ \ / / _ \ '_ \| __/ __|
  | |___ \ V /  __/ | | | |_\__ \
  |_____| \_/ \___|_| |_|\__|___/
                                 
 
*/

  ///Iniitalizes the fort
  Future<void> init() async {

    //Registers the storage system in flutter
    await Hive.initFlutter();

    //Opens the general box
    await storeBox<dynamic>(GENERAL_KEY);

    //Opens the general lazyBox
    lazyBox = await Hive.openLazyBox(LAZY_KEY);

  }

  ///Registers a type adapter to a key and opens the box for the objects. 
  ///Boxes must initlaly be registered before used
  Future<Box<T>> register<T>(String key, TypeAdapter<T> adapter) async {
    
    //Registers the storage system in flutter
    if(openBoxes.isEmpty){
      await init();
    }

    if(openBoxes[key] == null){
      //register the adapter if it is not registered
      registerAdapter(adapter);
    }
    
    //Returns the open box
    return await storeBox<T>(key);

  }

  ///Must be called after `init`
  void registerAdapter<T>(TypeAdapter<T> adapter){
    try{
      Hive.registerAdapter(adapter);
    }catch(e){}
  }

  ///Opens a box and returns an open box
  Future<Box<T>> storeBox<T>(String boxKey) async {

    // if(openBoxes[boxKey] == null){
    //   //Open the box
    //   Box<T> box = await Hive.openBox<T>(boxKey);
    //   openBoxes[boxKey] = box;
    //   return box;
    // }
    
    try{
      return openBoxes[boxKey] as Box<T>;
    }catch(e){
      //Open the box
      Box<T> box = await Hive.openBox<T>(boxKey);
      openBoxes[boxKey] = box;
      return box;
    }
  }

    ///Opens a box and returns an open box
  Box<T> box<T>(String boxKey) {
    
    if(isOpen<T>(boxKey)){
      //Box already open
      return openBoxes[boxKey] as Box<T>;
    }
    throw 'Box not open';
  }

  ///Returns an open store or null
  ValueListenable<Box<T>> getStoreListener<T>(String boxKey, [List<dynamic>? listenerKeys]) {
    if(openBoxes[boxKey] != null){
      //Box already open
      return Hive.box<T>(boxKey).listenable(keys: listenerKeys);
    }
    throw 'Box Not Open';
  }

  ///Returns if box is open
  bool isOpen<T>(String boxKey){
    return openBoxes[boxKey] != null;
  }

  /// Clear individual box
  /// Box Will remain open after being cleared
  Future<void> clearBox(String boxKey) async {
    try{
      await openBoxes[boxKey]!.clear();
    }catch(e){
      throw("Trying to close a box that is not contained inside of openBoxes");
    }
  }

  /// Clear individual box
  /// Box will be closed after it is cleared
  Future<void> deleteBox<T>(String boxKey) async {
    try{
      await openBoxes[boxKey]!.deleteFromDisk();
    }catch(e){
      throw("Trying to delete a box that is not contained inside of openBoxes");
    }
  }

  /// Clears everything inside the Fort except
  /// Does not clear Boxes that contain the [GENERAL_KEY]
  /// Boxes will remain open even after the Fort is cleared so they
  /// can still be access synchronously
  Future<void> clearFort() async {
    Iterable<String> keys = openBoxes.keys.skipWhile((value) => value == GENERAL_KEY);
    for(String key in keys){
      await clearBox(key);
    }
  }


  /// Deletes everything inside the Fort
  /// Boxes will be closed after they are cleared
  /// Deletes boxes that are reference from the [GENERAL_KEY]
  Future<void> deleteFort() async {
    for(String key in openBoxes.keys){
      await deleteBox(key);
    }
  }
}