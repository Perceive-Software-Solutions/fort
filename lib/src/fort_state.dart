
part of '../fort.dart';

///A class to use to extend all types of Tower States
abstract class FortState<T> extends HiveObject{

  FortState();

  //Overriden as a factory constructor
  FortState.fromJson(dynamic json);

  //To json method for persistant storage
  dynamic toJson();

  //Copy with functon
  FortState<T> copyWith(FortState<T> other);
} 