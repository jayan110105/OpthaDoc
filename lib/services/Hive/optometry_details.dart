import 'package:hive/hive.dart';

part 'optometry_details.g.dart';

@HiveType(typeId: 1)
class OptometryDetails extends HiveObject {
  @HiveField(0)
  String patientId;

  @HiveField(1)
  String? bifocal;

  @HiveField(2)
  String? color;

  @HiveField(3)
  String? remarks;

  @HiveField(4)
  String? dvSpR;

  @HiveField(5)
  String? dvSpL;

  @HiveField(6)
  String? nvSpR;

  @HiveField(7)
  String? nvSpL;

  @HiveField(8)
  String? cylR;

  @HiveField(9)
  String? cylL;

  @HiveField(10)
  String? dvr;

  @HiveField(11)
  String? dvl;

  @HiveField(12)
  String? aidedDVR;

  @HiveField(13)
  String? aidedDVL;

  @HiveField(14)
  String? nvr;

  @HiveField(15)
  String? nvl;

  @HiveField(16)
  String? axisR;

  @HiveField(17)
  String? axisL;

  @HiveField(18)
  String? ipd;

  @HiveField(19)
  String? briefComplaint;

  @HiveField(20)
  String? correctedDVSpR;

  @HiveField(21)
  String? correctedDVSpL;

  @HiveField(22)
  String? correctedNVSpR;

  @HiveField(23)
  String? correctedNVSpL;

  @HiveField(24)
  String? correctedCylR;

  @HiveField(25)
  String? correctedCylL;

  @HiveField(26)
  String? correctedDVR;

  @HiveField(27)
  String? correctedDVL;

  @HiveField(28)
  String? correctedNVR;

  @HiveField(29)
  String? correctedNVL;

  @HiveField(30)
  String? correctedAxisR;

  @HiveField(31)
  String? correctedAxisL;

  @HiveField(32)
  String? correctedIPD;

  @HiveField(33)
  DateTime createdAt;

  OptometryDetails({
    required this.patientId,
    this.bifocal,
    this.color,
    this.remarks,
    this.dvSpR,
    this.dvSpL,
    this.nvSpR,
    this.nvSpL,
    this.cylR,
    this.cylL,
    this.dvr,
    this.dvl,
    this.aidedDVR,
    this.aidedDVL,
    this.nvr,
    this.nvl,
    this.axisR,
    this.axisL,
    this.ipd,
    this.briefComplaint,
    this.correctedDVSpR,
    this.correctedDVSpL,
    this.correctedNVSpR,
    this.correctedNVSpL,
    this.correctedCylR,
    this.correctedCylL,
    this.correctedDVR,
    this.correctedDVL,
    this.correctedNVR,
    this.correctedNVL,
    this.correctedAxisR,
    this.correctedAxisL,
    this.correctedIPD,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'bifocal': bifocal,
      'color': color,
      'remarks': remarks,
      'dvSpR': dvSpR,
      'dvSpL': dvSpL,
      'nvSpR': nvSpR,
      'nvSpL': nvSpL,
      'cylR': cylR,
      'cylL': cylL,
      'dvr': dvr,
      'dvl': dvl,
      'aidedDVR': aidedDVR,
      'aidedDVL': aidedDVL,
      'nvr': nvr,
      'nvl': nvl,
      'axisR': axisR,
      'axisL': axisL,
      'ipd': ipd,
      'briefComplaint': briefComplaint,
      'correctedDVSpR': correctedDVSpR,
      'correctedDVSpL': correctedDVSpL,
      'correctedNVSpR': correctedNVSpR,
      'correctedNVSpL': correctedNVSpL,
      'correctedCylR': correctedCylR,
      'correctedCylL': correctedCylL,
      'correctedDVR': correctedDVR,
      'correctedDVL': correctedDVL,
      'correctedNVR': correctedNVR,
      'correctedNVL': correctedNVL,
      'correctedAxisR': correctedAxisR,
      'correctedAxisL': correctedAxisL,
      'correctedIPD': correctedIPD,
      'createdAt': createdAt,
    };
  }
}