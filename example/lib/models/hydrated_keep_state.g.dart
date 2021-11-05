// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hydrated_keep_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HydratedKeepStatesAdapter extends TypeAdapter<HydratedKeepStates> {
  @override
  final int typeId = 2;

  @override
  HydratedKeepStates read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HydratedKeepStates.DEACTIVE;
      case 1:
        return HydratedKeepStates.ACTIVE;
      default:
        return HydratedKeepStates.DEACTIVE;
    }
  }

  @override
  void write(BinaryWriter writer, HydratedKeepStates obj) {
    switch (obj) {
      case HydratedKeepStates.DEACTIVE:
        writer.writeByte(0);
        break;
      case HydratedKeepStates.ACTIVE:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HydratedKeepStatesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
