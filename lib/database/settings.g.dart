// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings()
      ..alarmEnabled = fields[0] as bool
      ..alarmTimeHour = fields[1] as int
      ..alarmTimeMinute = fields[2] as int
      ..alarmWeekdays = (fields[3] as List).cast<bool>();
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.alarmEnabled)
      ..writeByte(1)
      ..write(obj.alarmTimeHour)
      ..writeByte(2)
      ..write(obj.alarmTimeMinute)
      ..writeByte(3)
      ..write(obj.alarmWeekdays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
