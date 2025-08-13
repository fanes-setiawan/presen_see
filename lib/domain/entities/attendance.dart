import '../../data/models/attendance_model.dart';

class Attendance {
  final String id;
  final String userId;
  final String name;
  final String date;
  final String time;
  final double latitude;
  final double longitude;
  final String locationStatus;
  final String photoUrl;
  final bool synced;

  Attendance({
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

  factory Attendance.fromModel(AttendanceModel m) => Attendance(
        id: m.id,
        userId: m.userId,
        name: m.name,
        date: m.date,
        time: m.time,
        latitude: m.latitude,
        longitude: m.longitude,
        locationStatus: m.locationStatus,
        photoUrl: m.photoUrl,
        synced: m.synced,
      );
}
