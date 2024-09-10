// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patients.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientsAdapter extends TypeAdapter<Patients> {
  @override
  final int typeId = 0;

  @override
  Patients read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patients(
      name: fields[0] as String,
      age: fields[1] as String,
      aadhaarNumber: fields[2] as String,
      phoneNumber: fields[3] as String,
      parentSpouseName: fields[4] as String,
      address: fields[5] as String,
      gender: fields[6] as String,
      createdAt: fields[7] as String,
      imagePath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Patients obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.aadhaarNumber)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.parentSpouseName)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
