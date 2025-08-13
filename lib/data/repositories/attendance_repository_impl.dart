import 'dart:io';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_local_datasource.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource local;
  final AttendanceRemoteDataSource remote;

  AttendanceRepositoryImpl({required this.local, required this.remote});

  @override
  Future<void> addAttendance(Attendance attendance, File photoFile) async {
    final model = AttendanceModel(
      id: attendance.id,
      userId: attendance.userId,
      name: attendance.name,
      date: attendance.date,
      time: attendance.time,
      latitude: attendance.latitude,
      longitude: attendance.longitude,
      locationStatus: attendance.locationStatus,
      photoUrl: attendance.photoUrl,
      synced: attendance.synced,
    );

    await local.cacheAttendance(model);

    try {
      await remote.uploadAttendance(model, photoFile);
      await local.markSynced(model.id);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<Attendance>> getAttendances(String userId) async {
    final localList = await local.getCachedAttendances();
    final mappedLocal =
        localList
            .where((e) => e.userId == userId)
            .map((m) => Attendance.fromModel(m))
            .toList();

    return mappedLocal;
  }

  @override
  Future<void> syncPending() async {
    final all = await local.getCachedAttendances();
    for (final a in all.where((e) => !e.synced)) {
      try {
        final file = File(a.photoUrl);
        await remote.uploadAttendance(a, file);
        await local.markSynced(a.id);
      } catch (_) {}
    }
  }
}
