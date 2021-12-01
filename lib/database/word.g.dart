// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 0;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word(
      name: fields[0] as String,
      def: fields[1] as String,
      ex: fields[2] as String,
      mnemonic: fields[3] as String?,
      level: fields[4] as int,
      syncId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.def)
      ..writeByte(2)
      ..write(obj.ex)
      ..writeByte(3)
      ..write(obj.mnemonic)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.syncId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
