// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserKeepStateAdapter extends TypeAdapter<UserKeepState> {
  @override
  final int typeId = 3;

  @override
  UserKeepState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserKeepState(
      state: fields[0] as HydratedKeepStates,
      hydrate: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserKeepState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.state)
      ..writeByte(1)
      ..write(obj.hydrate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserKeepStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
