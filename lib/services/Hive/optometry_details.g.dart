// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optometry_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OptometryDetailsAdapter extends TypeAdapter<OptometryDetails> {
  @override
  final int typeId = 1;

  @override
  OptometryDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OptometryDetails(
      patientId: fields[0] as String,
      bifocal: fields[1] as String?,
      color: fields[2] as String?,
      remarks: fields[3] as String?,
      dvSpR: fields[4] as String?,
      dvSpL: fields[5] as String?,
      nvSpR: fields[6] as String?,
      nvSpL: fields[7] as String?,
      cylR: fields[8] as String?,
      cylL: fields[9] as String?,
      dvr: fields[10] as String?,
      dvl: fields[11] as String?,
      aidedDVR: fields[12] as String?,
      aidedDVL: fields[13] as String?,
      nvr: fields[14] as String?,
      nvl: fields[15] as String?,
      axisR: fields[16] as String?,
      axisL: fields[17] as String?,
      ipd: fields[18] as String?,
      briefComplaint: fields[19] as String?,
      correctedDVSpR: fields[20] as String?,
      correctedDVSpL: fields[21] as String?,
      correctedNVSpR: fields[22] as String?,
      correctedNVSpL: fields[23] as String?,
      correctedCylR: fields[24] as String?,
      correctedCylL: fields[25] as String?,
      correctedDVR: fields[26] as String?,
      correctedDVL: fields[27] as String?,
      correctedNVR: fields[28] as String?,
      correctedNVL: fields[29] as String?,
      correctedAxisR: fields[30] as String?,
      correctedAxisL: fields[31] as String?,
      correctedIPD: fields[32] as String?,
      createdAt: fields[33] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OptometryDetails obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.patientId)
      ..writeByte(1)
      ..write(obj.bifocal)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.remarks)
      ..writeByte(4)
      ..write(obj.dvSpR)
      ..writeByte(5)
      ..write(obj.dvSpL)
      ..writeByte(6)
      ..write(obj.nvSpR)
      ..writeByte(7)
      ..write(obj.nvSpL)
      ..writeByte(8)
      ..write(obj.cylR)
      ..writeByte(9)
      ..write(obj.cylL)
      ..writeByte(10)
      ..write(obj.dvr)
      ..writeByte(11)
      ..write(obj.dvl)
      ..writeByte(12)
      ..write(obj.aidedDVR)
      ..writeByte(13)
      ..write(obj.aidedDVL)
      ..writeByte(14)
      ..write(obj.nvr)
      ..writeByte(15)
      ..write(obj.nvl)
      ..writeByte(16)
      ..write(obj.axisR)
      ..writeByte(17)
      ..write(obj.axisL)
      ..writeByte(18)
      ..write(obj.ipd)
      ..writeByte(19)
      ..write(obj.briefComplaint)
      ..writeByte(20)
      ..write(obj.correctedDVSpR)
      ..writeByte(21)
      ..write(obj.correctedDVSpL)
      ..writeByte(22)
      ..write(obj.correctedNVSpR)
      ..writeByte(23)
      ..write(obj.correctedNVSpL)
      ..writeByte(24)
      ..write(obj.correctedCylR)
      ..writeByte(25)
      ..write(obj.correctedCylL)
      ..writeByte(26)
      ..write(obj.correctedDVR)
      ..writeByte(27)
      ..write(obj.correctedDVL)
      ..writeByte(28)
      ..write(obj.correctedNVR)
      ..writeByte(29)
      ..write(obj.correctedNVL)
      ..writeByte(30)
      ..write(obj.correctedAxisR)
      ..writeByte(31)
      ..write(obj.correctedAxisL)
      ..writeByte(32)
      ..write(obj.correctedIPD)
      ..writeByte(33)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptometryDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
