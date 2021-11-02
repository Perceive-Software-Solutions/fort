
part of '../fort.dart';

///A class to use to extend all types of Tower States
abstract class FortState{

  //Overriden as a factory constructor
  FortState.fromJson(dynamic json);

  //To json method for persistant storage
  dynamic toJson();
}