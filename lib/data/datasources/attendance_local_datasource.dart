import 'package:hive/hive.dart';
import '../models/attendance_model.dart';

abstract class AttendanceLocalDataSource {
  Future<void> cacheAttendance(AttendanceModel attendance);
  Future<List<AttendanceModel>> getCachedAttendances();
  Future<void> markSynced(String id);
}

class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  final Box<AttendanceModel> box;

  AttendanceLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheAttendance(AttendanceModel attendance) async {
    await box.put(attendance.id, attendance);
  }

  @override
  Future<List<AttendanceModel>> getCachedAttendances() async {
    return box.values.toList();
  }

  @override
  Future<void> markSynced(String id) async {
    final a = box.get(id);
    if (a != null) {
      final updated = AttendanceModel(
        id: a.id,
        userId: a.userId,
        name: a.name,
        date: a.date,
        time: a.time,
        latitude: a.latitude,
        longitude: a.longitude,
        locationStatus: a.locationStatus,
        photoUrl: a.photoUrl,
        synced: true,
      );
      await box.put(id, updated);
    }
  }
}
