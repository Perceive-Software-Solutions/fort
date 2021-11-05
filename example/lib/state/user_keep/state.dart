import 'package:fort/fort.dart';
import 'package:fort_example/api/mock_api.dart';
import 'package:fort_example/models/hydrated_keep_state.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/state/fort_keys.dart';

part 'keep.dart';
part 'reducer.dart';

part 'state.g.dart';

/*
 
   ____  _        _       
  / ___|| |_ __ _| |_ ___ 
  \___ \| __/ _` | __/ _ \
   ___) | || (_| | ||  __/
  |____/ \__\__,_|\__\___|
                          
 
*/

@HiveType(typeId: 3)
class UserKeepState extends FortState<User>{

  /// ~~~~~~~~~~~~~~~~~~~~~~~~~~~ STATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ///The condition of the state
  @HiveField(0)
  final HydratedKeepStates state;
  
  @HiveField(1)
  String? hydrate;

  /// ~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOWER ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  UserKeepState({
    this.state = HydratedKeepStates.DEACTIVE,
    this.hydrate
  });

  factory UserKeepState.initial() => UserKeepState();

  @override
  toJson() => {};

  @override
  FortState<User> copyWith(FortState<User> other) {
    return this;
  }
}