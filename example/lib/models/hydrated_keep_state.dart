
import 'package:fort/fort.dart';

part 'hydrated_keep_state.g.dart';

///Asset type enum
@HiveType(typeId: 2)
enum HydratedKeepStates {

  @HiveField(0)
  DEACTIVE, //Not Hydrated

  @HiveField(1)
  ACTIVE, //Hydrated
}