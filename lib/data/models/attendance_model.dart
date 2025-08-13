// lib/data/models/attendance_model.dart
import 'package:hive/hive.dart';

part 'attendance_model.g.dart';

@HiveType(typeId: 0)
class AttendanceModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final String time;

  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  @HiveField(7)
  final String locationStatus;

  @HiveField(8)
  final String photoUrl;

  @HiveField(9)
  final bool synced;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.date,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.locationStatus,
    required this.photoUrl,
    required this.synced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'date': date,
      'time': time,
      'latitude': latitude,
      'longitude': longitude,
      'locationStatus': locationStatus,
      'photoUrl': photoUrl,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      latitude: (map['latitude'] is num) ? (map['latitude'] as num).toDouble() : 0.0,
      longitude: (map['longitude'] is num) ? (map['longitude'] as num).toDouble() : 0.0,
      locationStatus: map['locationStatus'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      synced: map['synced'] ?? true,
    );
  }
}
