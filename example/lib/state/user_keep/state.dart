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
  final HydratedKeepStates? state;
  
  @HiveField(1)
  String? hydratedTime;

  @HiveField(2)
  int? follows;

  /// ~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOWER ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  UserKeepState({
    this.state,
    this.hydratedTime,
    this.follows
  });

  factory UserKeepState.initial() => UserKeepState(state: HydratedKeepStates.DEACTIVE);

  @override
  toJson() => {};

  @override
  FortState<User> copyWith(FortState<User> other) {
    if(other is UserKeepState){
      return UserKeepState(
        state: other.state ?? state,
        hydratedTime: other.hydratedTime ?? hydratedTime,
        follows: other.follows ?? follows
      );
    }
    return this;
  }
}