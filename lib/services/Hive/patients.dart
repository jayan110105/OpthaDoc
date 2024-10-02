import 'package:hive/hive.dart';

part 'patients.g.dart';

@HiveType(typeId: 0)
class Patients extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String age;

  @HiveField(2)
  String aadhaarNumber;

  @HiveField(3)
  String phoneNumber;

  @HiveField(4)
  String parentSpouseName;

  @HiveField(5)
  String address;

  @HiveField(6)
  String gender;

  @HiveField(7)
  String createdAt;

  @HiveField(8)
  String? imagePath;

  Patients({
    required this.name,
    required this.age,
    required this.aadhaarNumber,
    required this.phoneNumber,
    required this.parentSpouseName,
    required this.address,
    required this.gender,
    required this.createdAt,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'aadhaarNumber': aadhaarNumber,
      'phoneNumber': phoneNumber,
      'parentSpouseName': parentSpouseName,
      'address': address,
      'gender': gender,
      'imageUrl': imagePath,
    };
  }
}