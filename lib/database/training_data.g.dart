// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrainingDataAdapter extends TypeAdapter<TrainingData> {
  @override
  final int typeId = 2;

  @override
  TrainingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrainingData(
      expiration: fields[0] as DateTime,
      wordKeys: (fields[1] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, TrainingData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.expiration)
      ..writeByte(1)
      ..write(obj.wordKeys);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
