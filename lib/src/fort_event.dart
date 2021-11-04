
part of '../fort.dart';

///A class to use to extend all types of Tower Events
abstract class FortEvent{}

/*
 
   ____        __             _ _     _____                 _       
  |  _ \  ___ / _| __ _ _   _| | |_  | ____|_   _____ _ __ | |_ ___ 
  | | | |/ _ \ |_ / _` | | | | | __| |  _| \ \ / / _ \ '_ \| __/ __|
  | |_| |  __/  _| (_| | |_| | | |_  | |___ \ V /  __/ | | | |_\__ \
  |____/ \___|_|  \__,_|\__,_|_|\__| |_____| \_/ \___|_| |_|\__|___/
                                                                    
 
*/

///Set state event sets the current state to the one provided
class SetState<T> extends FortEvent{

  final FortState<T> state;

  SetState(this.state);

}

///Copy with event
class CopyStateWith<T> extends FortEvent{

  final FortState<T> state;

  CopyStateWith(this.state);

}